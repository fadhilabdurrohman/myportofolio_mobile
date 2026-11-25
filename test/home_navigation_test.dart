import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/menu_card.dart';

import 'support/test_api.dart';

Future<void> bukaHome(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 900);

  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(MyApp(apiClient: fakeApi()));
  await tester.pumpAndSettle();
}

Future<void> tekanKartu(WidgetTester tester, String nama) async {
  final kartu = find.widgetWithText(ItemCard, nama);
  await tester.ensureVisible(kartu);
  await tester.tap(kartu);
  await tester.pumpAndSettle();
}

Future<void> bukaDrawer(WidgetTester tester) async {
  await tester.tap(find.byType(DrawerButton));
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester) async {
  await isiKolom(tester, 'Username', 'owner');
  await isiKolom(tester, 'Password', 'test-password');

  await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
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
      'Login',
    ]) {
      expect(find.widgetWithText(ItemCard, nama), findsOneWidget);
    }
  });

  final daftarPublik = {
    'Lihat Proyek': 'Belum ada proyek.',
    'Lihat Pengalaman': 'Belum ada pengalaman.',
  };

  for (final tujuan in daftarPublik.entries) {
    testWidgets('${tujuan.key} dapat dibuka tanpa login', (tester) async {
      await bukaHome(tester);
      await tekanKartu(tester, tujuan.key);

      expect(find.text(tujuan.value), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  }

  testWidgets('Membatalkan login mengembalikan pengguna ke Home', (
    tester,
  ) async {
    await bukaHome(tester);
    await tekanKartu(tester, 'Tambah Proyek');

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.widgetWithText(ItemCard, 'Login'), findsOneWidget);
  });

  final formulir = <String, Type>{
    'Tambah Proyek': ProjectFormPage,
    'Tambah Pengalaman': ExperienceFormPage,
  };

  for (final tujuan in formulir.entries) {
    testWidgets('${tujuan.key} meminta login lalu membuka formulir tujuan', (
      tester,
    ) async {
      await bukaHome(tester);
      await tekanKartu(tester, tujuan.key);

      expect(find.byType(LoginScreen), findsOneWidget);

      await login(tester);

      expect(find.byType(tujuan.value), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.widgetWithText(ItemCard, 'Logout'), findsOneWidget);
    });
  }

  testWidgets('Drawer Add Experience meminta login dan Home kembali ke awal', (
    tester,
  ) async {
    await bukaHome(tester);
    await bukaDrawer(tester);

    await tester.tap(find.widgetWithText(ListTile, 'Add Experience'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    await login(tester);
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await bukaDrawer(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.widgetWithText(ItemCard, 'Logout'), findsOneWidget);
  });

  testWidgets('Setelah logout, membuka formulir meminta login lagi', (
    tester,
  ) async {
    await bukaHome(tester);
    await tekanKartu(tester, 'Login');
    await login(tester);

    expect(find.widgetWithText(ItemCard, 'Logout'), findsOneWidget);

    await tekanKartu(tester, 'Logout');
    expect(find.widgetWithText(ItemCard, 'Login'), findsOneWidget);

    await tekanKartu(tester, 'Tambah Pengalaman');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });
}
