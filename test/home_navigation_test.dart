import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/menu_card.dart';

Future<void> bukaHome(WidgetTester tester) async {
  // Gunakan layar yang cukup luas agar semua kartu dapat ditekan.
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

Future<void> bukaDrawer(WidgetTester tester) async {
  await tester.tap(find.byType(DrawerButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Home menampilkan identitas dan lima kartu menu', (tester) async {
    await bukaHome(tester);

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('2506656690'), findsOneWidget);
    expect(find.text('Fadhil Abdurrohman'), findsOneWidget);
    expect(find.text('PBP B'), findsOneWidget);
    expect(find.byType(ItemCard), findsNWidgets(5));

    for (final nama in [
      'Lihat Proyek',
      'Tambah Proyek',
      'Lihat Pengalaman',
      'Tambah Pengalaman',
      'Logout',
    ]) {
      expect(find.widgetWithText(ItemCard, nama), findsOneWidget);
    }
  });

  // Ketiga kartu ini menampilkan SnackBar dan pengguna tetap di Home.
  for (final nama in ['Lihat Proyek', 'Lihat Pengalaman', 'Logout']) {
    testWidgets('Kartu $nama menampilkan SnackBar', (tester) async {
      await bukaHome(tester);

      await tester.tap(find.widgetWithText(ItemCard, nama));
      await tester.pumpAndSettle();

      expect(find.byType(MyHomePage), findsOneWidget);
      expect(
        find.widgetWithText(SnackBar, 'Kamu telah menekan tombol $nama!'),
        findsOneWidget,
      );
    });
  }

  // Satu tes untuk setiap pasangan kartu dan halaman tujuan.
  final tujuanKartu = <String, Type>{
    'Tambah Proyek': ProjectFormPage,
    'Tambah Pengalaman': ExperienceFormPage,
  };

  for (final tujuan in tujuanKartu.entries) {
    testWidgets(
      'Kartu ${tujuan.key} membuka form dan bisa kembali',
      (tester) async {
        await bukaHome(tester);

        final kartu = find.widgetWithText(ItemCard, tujuan.key);
        await tester.ensureVisible(kartu);
        await tester.tap(kartu);
        await tester.pumpAndSettle();

        expect(find.byType(tujuan.value), findsOneWidget);
        expect(
          find.widgetWithText(
            SnackBar,
            'Kamu telah menekan tombol ${tujuan.key}!',
          ),
          findsOneWidget,
        );

        // Simulasikan tombol kembali pada perangkat.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(find.byType(MyHomePage), findsOneWidget);
      },
    );
  }
}