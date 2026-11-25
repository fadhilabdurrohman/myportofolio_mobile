import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'support/test_api.dart';

void main() {
  testWidgets('Nama, deskripsi, dan tahun proyek wajib valid', (tester) async {
    await tester.pumpWidget(formApp(const ProjectFormPage()));

    await isiKolom(tester, 'Nama Proyek', '   ');
    await tekanSave(tester);

    expect(find.text('Kolom ini wajib diisi.'), findsNWidgets(2));
    expect(find.text('Masukkan tahun 1900–2100.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tahun di luar rentang ditolak sebelum mengirim POST', (
    tester,
  ) async {
    var jumlahPost = 0;

    await tester.pumpWidget(
      formApp(
        const ProjectFormPage(),
        inspect: (request) {
          if (request.method == 'POST') jumlahPost++;
        },
      ),
    );

    await isiKolom(tester, 'Nama Proyek', 'ShareSpace');
    await isiKolom(tester, 'Deskripsi Proyek', 'Aplikasi peminjaman');

    for (final tahun in ['1899', '2101']) {
      await isiKolom(tester, 'Tahun', tahun);
      await tekanSave(tester);

      expect(find.text('Masukkan tahun 1900–2100.'), findsOneWidget);
    }

    expect(jumlahPost, 0);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tautan proyek yang tidak valid ditolak', (tester) async {
    await tester.pumpWidget(formApp(const ProjectFormPage()));

    await isiKolom(tester, 'Nama Proyek', 'ShareSpace');
    await isiKolom(tester, 'Deskripsi Proyek', 'Aplikasi peminjaman');
    await isiKolom(tester, 'Tahun', '2026');
    await isiKolom(tester, 'Tautan Proyek', 'bukan-url');
    await tekanSave(tester);

    expect(find.textContaining('Masukkan URL lengkap'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Proyek bisa disimpan ketika URL dan gambar dikosongkan', (
    tester,
  ) async {
    Map<String, dynamic>? payload;

    await tester.pumpWidget(
      formApp(
        const ProjectFormPage(),
        inspect: (request) {
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/projects/') {
            payload = jsonDecode(request.body) as Map<String, dynamic>;
          }
        },
      ),
    );

    await isiKolom(tester, 'Nama Proyek', 'MyPortfolio');
    await isiKolom(tester, 'Deskripsi Proyek', 'Portofolio pribadi');
    await isiKolom(tester, 'Tahun', '2026');
    await tekanSave(tester);

    expect(payload, isNotNull);
    expect(payload!['url'], isNull);
    expect(payload!['thumbnail'], isNull);
    expect(payload!['project_type'], 'Web Development');
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
  });

  testWidgets('Save mengirim data Project dan OK mengosongkan formulir', (
    tester,
  ) async {
    Map<String, dynamic>? payload;
    String? authorization;
    var jumlahPost = 0;

    await tester.pumpWidget(
      formApp(
        const ProjectFormPage(),
        inspect: (request) {
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/projects/') {
            jumlahPost++;
            payload = jsonDecode(request.body) as Map<String, dynamic>;
            authorization = request.headers['Authorization'];
          }
        },
      ),
    );

    await isiKolom(tester, 'Nama Proyek', 'ShareSpace');
    await isiKolom(tester, 'Deskripsi Proyek', 'Aplikasi peminjaman');
    await isiKolom(tester, 'Tahun', '2026');

    final dropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mobile Development').hitTestable());
    await tester.pumpAndSettle();

    await isiKolom(tester, 'Tautan Proyek', 'https://example.com/project');
    await isiKolom(tester, 'URL Gambar', 'https://example.com/image.png');
    await tekanSave(tester);

    expect(jumlahPost, 1);
    expect(authorization, 'Token $testToken');
    expect(payload, {
      'title': 'ShareSpace',
      'description': 'Aplikasi peminjaman',
      'year': 2026,
      'project_type': 'Mobile Development',
      'url': 'https://example.com/project',
      'thumbnail': 'https://example.com/image.png',
    });

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: ShareSpace'), findsOneWidget);
    expect(find.text('Tahun: 2026'), findsOneWidget);
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);

    await tekanOk(tester);

    expect(find.byType(AlertDialog), findsNothing);
    for (final label in [
      'Nama Proyek',
      'Deskripsi Proyek',
      'Tahun',
      'Tautan Proyek',
      'URL Gambar',
    ]) {
      expect(isiKolomSaatIni(tester, label), isEmpty);
    }
  });
}
