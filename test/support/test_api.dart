import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

const testToken = 'test-token';

http.Response jsonResponse(Object data, int status) {
  return http.Response(
    jsonEncode(data),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

ApiClient fakeApi({void Function(http.Request)? inspect}) {
  final client = MockClient((request) async {
    inspect?.call(request);

    final path = request.url.path;
    final isCollection =
        path == '/api/v1/projects/' || path == '/api/v1/experiences/';

    // Kedua daftar dapat dibaca tanpa login.
    if (request.method == 'GET' && isCollection) {
      return jsonResponse([], 200);
    }

    // Akun untuk tes navigasi dan login.
    if (request.method == 'POST' && path == '/api/v1/auth/token/') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;

      if (body['username'] == 'owner' && body['password'] == 'test-password') {
        return jsonResponse({'token': testToken}, 200);
      }

      return jsonResponse({
        'non_field_errors': ['Username atau password salah.'],
      }, 400);
    }

    // Membuat data dan logout membutuhkan token.
    if (request.headers['Authorization'] != 'Token $testToken') {
      return jsonResponse({'detail': 'Invalid token.'}, 401);
    }

    if (request.method == 'POST' && path == '/api/v1/auth/logout/') {
      return http.Response('', 204);
    }

    if (request.method == 'POST' && isCollection) {
      final body = jsonDecode(request.body) as Map<String, dynamic>;

      return jsonResponse({
        ...body,
        'id': '762dde5d-f7d6-47b4-bae7-860e0052e579',
        'star_count': 0,
      }, 201);
    }

    return jsonResponse({'detail': 'Not found.'}, 404);
  });

  return ApiClient(client: client);
}

// Membuka satu formulir dengan kondisi pengguna sudah login.
// Dengan demikian, tes formulir bisa fokus pada validasi dan data POST.
Widget formApp(Widget page, {void Function(http.Request)? inspect}) {
  final api = fakeApi(inspect: inspect);
  addTearDown(api.close);

  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: api),
      ChangeNotifierProvider<AuthState>(
        create: (_) => AuthState(api, initialToken: testToken),
      ),
    ],
    child: MaterialApp(home: page),
  );
}

Finder kolom(String label) {
  return find.widgetWithText(TextFormField, label);
}

Future<void> isiKolom(WidgetTester tester, String label, String isi) async {
  final field = kolom(label);
  await tester.ensureVisible(field);
  await tester.enterText(field, isi);
  await tester.pump();
}

Future<void> tekanSave(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> tekanOk(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(TextButton, 'OK'));
  await tester.pumpAndSettle();
}

String isiKolomSaatIni(WidgetTester tester, String label) {
  final editable = find.descendant(
    of: kolom(label),
    matching: find.byType(EditableText),
  );

  return tester.widget<EditableText>(editable).controller.text;
}
