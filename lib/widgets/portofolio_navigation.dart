import 'package:flutter/material.dart';

import '../screens/experience_form.dart';
import '../screens/portofolio_lists.dart';
import '../screens/project_form.dart';
import 'auth_guard.dart';

Future<void> openPortfolioMenu(BuildContext context, String menu) async {
  if (menu == 'Login') {
    await ensureLoggedIn(context);
    return;
  }
  if (menu == 'Logout') {
    await logoutWithMessage(context);
    return;
  }

  final protected = menu == 'Tambah Proyek' || menu == 'Tambah Pengalaman';
  if (protected) {
    final allowed = await ensureLoggedIn(context);
    if (!context.mounted || !allowed) return;
  }

  final Widget page = switch (menu) {
    'Lihat Proyek' => const ProjectListScreen(),
    'Tambah Proyek' => const ProjectFormPage(),
    'Lihat Pengalaman' => const ExperienceListScreen(),
    'Tambah Pengalaman' => const ExperienceFormPage(),
    _ => throw ArgumentError.value(menu, 'menu'),
  };

  if (!context.mounted) return;
  await Navigator.of(context)
      .push<void>(MaterialPageRoute(builder: (_) => page));
}
