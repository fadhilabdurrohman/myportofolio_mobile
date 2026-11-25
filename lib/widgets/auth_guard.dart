import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;

  final result = await Navigator.of(context)
      .push<bool>(MaterialPageRoute(builder: (_) => const LoginScreen()));
  return result ?? false;
}

Future<void> logoutWithMessage(BuildContext context) async {
  var message = 'Berhasil logout.';
  try {
    await context.read<AuthState>().logout();
  } on Exception {
    message =
        'Sesi lokal ditutup. Pencabutan token di server belum terkonfirmasi.';
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
