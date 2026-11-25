import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

import 'support/test_api.dart';

Future<void> isiDataWajib(WidgetTester tester) async {
  await isiKolom(tester, 'Nama Experience', 'Asisten Dosen');
  await isiKolom(tester, 'Nama organisasi', 'Fasilkom UI');
  await isiKolom(tester, 'Deskripsi pengalaman', 'Membantu kegiatan praktikum');
  await isiKolom(tester, 'Tanggal mulai', '2026-11-25');
}

void main() {
  testWidgets('Kolom kosong, spasi, dan tag tanpa isi ditolak', (tester) async {
    await tester.pumpWidget(formApp(const ExperienceFormPage()));

    await isiKolom(tester, 'Nama Experience', '<b></b>');
    await isiKolom(tester, 'Nama organisasi', '   ');
    await tekanSave(tester);

    for (final label in [
      'Nama Experience',
      'Nama organisasi',
      'Deskripsi pengalaman',
    ]) {
      expect(
        find.descendant(
          of: kolom(label),
          matching: find.text('Kolom ini wajib diisi.'),
        ),
        findsOneWidget,
      );
    }

    expect(
      find.text('Isi tanggal mulai dalam format YYYY-MM-DD.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Nama pengalaman dan organisasi menolak 256 karakter', (
    tester,
  ) async {
    await tester.pumpWidget(formApp(const ExperienceFormPage()));

    final panjang256 = List.filled(256, 'a').join();

    await isiKolom(tester, 'Nama Experience', panjang256);
    await isiKolom(tester, 'Nama organisasi', panjang256);
    await isiKolom(tester, 'Deskripsi pengalaman', 'Deskripsi valid');
    await isiKolom(tester, 'Tanggal mulai', '2026-11-25');
    await tekanSave(tester);

    for (final label in ['Nama Experience', 'Nama organisasi']) {
      expect(
        find.descendant(
          of: kolom(label),
          matching: find.text('Panjang maksimal 255 karakter.'),
        ),
        findsOneWidget,
      );
    }

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tanggal mulai harus merupakan tanggal kalender yang valid', (
    tester,
  ) async {
    await tester.pumpWidget(formApp(const ExperienceFormPage()));
    await isiDataWajib(tester);

    await isiKolom(tester, 'Tanggal mulai', '2026-02-30');
    await tekanSave(tester);

    expect(
      find.text('Isi tanggal mulai dalam format YYYY-MM-DD.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tanggal selesai sebelum tanggal mulai ditolak tanpa POST', (
    tester,
  ) async {
    var jumlahPost = 0;

    await tester.pumpWidget(
      formApp(
        const ExperienceFormPage(),
        inspect: (request) {
          if (request.method == 'POST') jumlahPost++;
        },
      ),
    );

    await isiDataWajib(tester);
    await isiKolom(tester, 'Tanggal selesai', '2026-11-24');
    await tekanSave(tester);

    expect(
      find.text('Tanggal selesai harus sama atau sesudah tanggal mulai.'),
      findsOneWidget,
    );
    expect(jumlahPost, 0);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Pengalaman yang masih berlangsung dapat disimpan', (
    tester,
  ) async {
    Map<String, dynamic>? payload;

    await tester.pumpWidget(
      formApp(
        const ExperienceFormPage(),
        inspect: (request) {
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/experiences/') {
            payload = jsonDecode(request.body) as Map<String, dynamic>;
          }
        },
      ),
    );

    await isiDataWajib(tester);
    await tekanSave(tester);

    expect(payload, isNotNull);
    expect(payload!['category'], 'full-time');
    expect(payload!['started_at'], '2026-11-25');
    expect(payload!['ended_at'], isNull);
    expect(payload!['thumbnail'], isNull);

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Selesai: Masih berlangsung'), findsOneWidget);
  });

  testWidgets('Save membersihkan teks dan mengirim kode kategori ke Django', (
    tester,
  ) async {
    Map<String, dynamic>? payload;
    String? authorization;
    var jumlahPost = 0;

    await tester.pumpWidget(
      formApp(
        const ExperienceFormPage(),
        inspect: (request) {
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/experiences/') {
            jumlahPost++;
            payload = jsonDecode(request.body) as Map<String, dynamic>;
            authorization = request.headers['Authorization'];
          }
        },
      ),
    );

    await isiKolom(tester, 'Nama Experience', '  <b>Asisten Dosen</b>  ');
    await isiKolom(tester, 'Nama organisasi', '<i>Fasilkom UI</i>');
    await isiKolom(tester, 'Deskripsi pengalaman', ' Membantu <b>riset</b> ');

    final dropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Research').hitTestable());
    await tester.pumpAndSettle();

    await isiKolom(tester, 'Tanggal mulai', '2026-11-25');
    await isiKolom(tester, 'Tanggal selesai', '2026-12-15');
    await isiKolom(tester, 'URL Gambar', 'https://example.com/research.png');
    await tekanSave(tester);

    expect(jumlahPost, 1);
    expect(authorization, 'Token $testToken');

    // Backend menerima kode "research", sedangkan dialog menampilkan "Research".
    expect(payload, {
      'title': 'Asisten Dosen',
      'organization': 'Fasilkom UI',
      'description': 'Membantu riset',
      'category': 'research',
      'started_at': '2026-11-25',
      'ended_at': '2026-12-15',
      'thumbnail': 'https://example.com/research.png',
    });

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);

    for (final baris in [
      'Nama pengalaman: Asisten Dosen',
      'Organisasi: Fasilkom UI',
      'Deskripsi: Membantu riset',
      'Kategori: Research',
      'Mulai: 2026-11-25',
      'Selesai: 2026-12-15',
    ]) {
      expect(find.widgetWithText(AlertDialog, baris), findsOneWidget);
    }

    await tekanOk(tester);

    expect(find.byType(AlertDialog), findsNothing);

    for (final label in [
      'Nama Experience',
      'Nama organisasi',
      'Deskripsi pengalaman',
      'Tanggal mulai',
      'Tanggal selesai',
      'URL Gambar',
    ]) {
      expect(isiKolomSaatIni(tester, label), isEmpty);
    }
  });
}
