import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _busy = false;

  Future<void> _submit() async {
    if (_busy || !_key.currentState!.validate()) return;
    _key.currentState!.save();
    setState(() => _busy = true);

    try {
      await context.read<AuthState>().login(_username, _password);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      final message = error.statusCode == 400
          ? 'Login gagal (400). Periksa username dan password.'
          : error.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghubungi Django. Periksa URL dan koneksi.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Username wajib diisi.' : null,
              onSaved: (v) => _username = v!.trim(),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (v) =>
                  (v ?? '').isEmpty ? 'Password wajib diisi.' : null,
              onSaved: (v) => _password = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? 'Memproses...' : 'Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}
