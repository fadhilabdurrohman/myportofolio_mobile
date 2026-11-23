import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

// Cari kolom berdasarkan label agar tes tetap sesuai jika urutannya berubah.
Finder kolom(String label) => find.widgetWithText(TextFormField, label);

Future<void> bukaForm(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
}

Future<void> tekanSave(WidgetTester tester) async {
  final tombol = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Nama dan deskripsi proyek wajib diisi', (tester) async {
    await bukaForm(tester);

    // Isi nama dengan spasi dan biarkan deskripsi kosong.
    await tester.enterText(kolom('Nama Proyek'), '   ');
    await tekanSave(tester);

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'Ringkasan proyek tampil ketika hanya kolom wajib diisi',
    (tester) async {
      await bukaForm(tester);

      await tester.enterText(kolom('Nama Proyek'), 'MyPortfolio');
      await tester.enterText(kolom('Deskripsi Proyek'), 'Portofolio pribadi');
      await tekanSave(tester);

      // Kategori memakai nilai awal. Teknologi dan tautan boleh kosong.
      expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
      expect(find.text('Kategori: Web Development'), findsOneWidget);
      expect(find.text('Teknologi: '), findsOneWidget);
      expect(find.text('Tautan: '), findsOneWidget);
    },
  );

  testWidgets(
    'Ringkasan memuat data proyek dan OK mengosongkan teks',
    (tester) async {
      await bukaForm(tester);
      await tester.enterText(kolom('Nama Proyek'), 'ShareSpace');
      await tester.enterText(kolom('Deskripsi Proyek'), 'Aplikasi peminjaman');

      // Buka dropdown dan pilih kategori selain nilai awal.
      final kategori = find.byType(DropdownButtonFormField<String>);
      await tester.ensureVisible(kategori);
      await tester.tap(kategori);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mobile Development').hitTestable());
      await tester.pumpAndSettle();

      await tester.enterText(kolom('Teknologi yang Digunakan'), 'Flutter');
      await tester.enterText(kolom('Tautan Proyek'), 'https://example.com');
      await tekanSave(tester);

      // Periksa bahwa seluruh data muncul di dalam dialog ringkasan.
      for (final baris in [
        'Nama Proyek: ShareSpace',
        'Deskripsi: Aplikasi peminjaman',
        'Kategori: Mobile Development',
        'Teknologi: Flutter',
        'Tautan: https://example.com',
      ]) {
        expect(find.widgetWithText(AlertDialog, baris), findsOneWidget);
      }

      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      // Setelah OK ditekan, keempat kolom teks harus kosong kembali.
      final inputs = tester.widgetList<EditableText>(find.byType(EditableText));
      expect(inputs, hasLength(4));

      for (final input in inputs) {
        expect(input.controller.text, isEmpty);
      }
    },
  );
}
