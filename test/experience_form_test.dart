import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

Finder kolom(String label) => find.widgetWithText(TextFormField, label);

Future<void> bukaForm(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
}

Future<void> tekanSave(WidgetTester tester) async {
  final tombol = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Kolom kosong, spasi, dan tag tanpa isi ditolak', (tester) async {
    await bukaForm(tester);

    // Setelah dibersihkan, nama dan organisasi sama-sama kosong.
    // Deskripsi sengaja dibiarkan kosong.
    await tester.enterText(kolom('Nama Experience'), '<b></b>');
    await tester.enterText(kolom('Nama organisasi'), '   ');
    await tekanSave(tester);

    for (final label in [
      'Nama Experience',
      'Nama organisasi',
      'Deskripsi pengalaman',
    ]) {
      expect(
        find.descendant(
          of: kolom(label),
          matching: find.textContaining('wajib diisi'),
        ),
        findsOneWidget,
      );
    }

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Nama dan organisasi menolak 256 karakter', (tester) async {
    await bukaForm(tester);

    final panjang256 = List.filled(256, 'a').join();
    await tester.enterText(kolom('Nama Experience'), panjang256);
    await tester.enterText(kolom('Nama organisasi'), panjang256);
    await tester.enterText(kolom('Deskripsi pengalaman'), 'Deskripsi valid');
    await tekanSave(tester);

    // Pastikan pesan batas panjang muncul pada masing-masing kolom.
    for (final label in ['Nama Experience', 'Nama organisasi']) {
      expect(
        find.descendant(
          of: kolom(label),
          matching: find.textContaining('maksimal 255'),
        ),
        findsOneWidget,
      );
    }

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'Ringkasan membersihkan teks dan memakai kategori pilihan',
    (tester) async {
      await bukaForm(tester);

      await tester.enterText(
        kolom('Nama Experience'),
        '  <b>Asisten Dosen</b>  ',
      );
      await tester.enterText(kolom('Nama organisasi'), '<i>Fasilkom UI</i>');
      await tester.enterText(
        kolom('Deskripsi pengalaman'),
        ' Membantu <b>riset</b> ',
      );

      final kategori = find.byType(DropdownButtonFormField<String>);
      await tester.ensureVisible(kategori);
      await tester.tap(kategori);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Research').hitTestable());
      await tester.pumpAndSettle();
      await tekanSave(tester);

      // Ringkasan harus menampilkan teks setelah tag dan spasi tepi dihapus.
      for (final baris in [
        'Nama pengalaman: Asisten Dosen',
        'Organisasi: Fasilkom UI',
        'Deskripsi: Membantu riset',
        'Kategori: Research',
      ]) {
        expect(find.widgetWithText(AlertDialog, baris), findsOneWidget);
      }

      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      // Setelah dialog ditutup, ketiga kolom teks harus kosong kembali.
      final inputs = tester.widgetList<EditableText>(find.byType(EditableText));
      expect(inputs, hasLength(3));

      for (final input in inputs) {
        expect(input.controller.text, isEmpty);
      }
    },
  );
}
