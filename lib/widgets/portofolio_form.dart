import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';
import 'auth_guard.dart';
import 'left_drawer.dart';

String cleanText(String value) =>
    value.replaceAll(RegExp(r'</?[A-Za-z][^>]*>'), '').trim();

String? optionalText(String? value) {
  final text = (value ?? '').trim();
  return text.isEmpty ? null : text;
}

String? requiredText(String? value, {int? max}) {
  final text = cleanText(value ?? '');
  if (text.isEmpty) return 'Kolom ini wajib diisi.';
  if (max != null && text.runes.length > max) {
    return 'Panjang maksimal $max karakter.';
  }
  return null;
}

String? validateUrl(String? value) {
  final text = optionalText(value);
  if (text == null) return null;
  final uri = Uri.tryParse(text);
  if (uri == null ||
      !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      text.contains(RegExp(r'\s'))) {
    return 'Masukkan URL lengkap, misalnya https://example.com.';
  }
  if (text.length > 200) return 'URL maksimal 200 karakter.';
  return null;
}

TextFormField inputField(
  String label, {
  required FormFieldSetter<String> save,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? changed,
  TextInputType? keyboard,
  int lines = 1,
}) {
  return TextFormField(
    decoration: InputDecoration(labelText: label),
    maxLines: lines,
    keyboardType: keyboard,
    validator: validate,
    onChanged: changed,
    onSaved: save,
  );
}

class PortfolioForm extends StatefulWidget {
  const PortfolioForm({
    super.key,
    required this.title,
    required this.successTitle,
    required this.fields,
    required this.send,
  });

  final String title;
  final String successTitle;
  final List<Widget> fields;
  final Future<List<String>> Function(ApiClient api, String token) send;

  @override
  State<PortfolioForm> createState() => _PortfolioFormState();
}

class _PortfolioFormState extends State<PortfolioForm> {
  final _key = GlobalKey<FormState>();
  bool _busy = false;

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submit() async {
    final form = _key.currentState!;
    if (_busy || !form.validate()) return;
    form.save();
    setState(() => _busy = true);

    String? usedToken;
    try {
      final allowed = await ensureLoggedIn(context);
      if (!mounted || !allowed) return;

      final token = context.read<AuthState>().token;
      if (token == null) return;
      usedToken = token;

      final summary = await widget.send(context.read<ApiClient>(), token);
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(widget.successTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [for (final line in summary) Text(line)],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) form.reset();
    } on ApiException catch (error) {
      if (!mounted) return;

      if (error.statusCode == 401 && usedToken != null) {
        context.read<AuthState>().clearIfCurrent(usedToken);
        _message('Sesi berakhir. Login kembali, lalu tekan Save.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _message(
          'Akun ini tidak memiliki izin menambah data. Gunakan superuser.',
        );
      } else {
        _message(error.toString());
      }
    } on Exception {
      if (mounted) _message('Gagal menghubungi Django. Periksa koneksi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: const LeftDrawer(),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final field in widget.fields)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: field,
                ),
              ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: Text(_busy ? 'Menyimpan...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
