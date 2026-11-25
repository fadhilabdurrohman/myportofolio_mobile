import 'package:flutter/material.dart';

import '../models/experience.dart';
import '../widgets/portofolio_form.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  String _title = '';
  String _organization = '';
  String _description = '';
  String _category = 'full-time';
  String _start = '';
  String? _end;
  String? _thumbnail;

  bool _validDate(String text) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) return false;
    final date = DateTime.tryParse(text);
    if (date == null || date.year < 1) return false;
    return date.toIso8601String().split('T').first == text;
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioForm(
      title: 'Add Experience Form',
      successTitle: 'Experience berhasil ditambahkan!',
      fields: [
        inputField(
          'Nama Experience',
          validate: (v) => requiredText(v, max: 255),
          save: (v) => _title = cleanText(v!),
        ),
        inputField(
          'Nama organisasi',
          validate: (v) => requiredText(v, max: 255),
          save: (v) => _organization = cleanText(v!),
        ),
        inputField(
          'Deskripsi pengalaman',
          lines: 3,
          validate: (v) => requiredText(v),
          save: (v) => _description = cleanText(v!),
        ),
        DropdownButtonFormField<String>(
          initialValue: 'full-time',
          decoration: const InputDecoration(labelText: 'Kategori Pengalaman'),
          items: [
            for (final entry in experienceCategories.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: (_) {},
          onSaved: (v) => _category = v!,
        ),
        inputField(
          'Tanggal mulai',
          keyboard: TextInputType.datetime,
          changed: (v) => _start = v.trim(),
          validate: (v) => _validDate((v ?? '').trim())
              ? null
              : 'Isi tanggal mulai dalam format YYYY-MM-DD.',
          save: (v) => _start = v!.trim(),
        ),
        inputField(
          'Tanggal selesai',
          keyboard: TextInputType.datetime,
          validate: (v) {
            final end = optionalText(v);
            if (end == null) return null;
            if (!_validDate(end)) return 'Gunakan format YYYY-MM-DD.';
            if (_validDate(_start) && end.compareTo(_start) < 0) {
              return 'Tanggal selesai harus sama atau sesudah tanggal mulai.';
            }
            return null;
          },
          save: (v) => _end = optionalText(v),
        ),
        inputField(
          'URL Gambar',
          keyboard: TextInputType.url,
          validate: validateUrl,
          save: (v) => _thumbnail = optionalText(v),
        ),
      ],
      send: (api, token) async {
        final saved = await api.createExperience(
          Experience(
            title: _title,
            organization: _organization,
            description: _description,
            category: _category,
            startedAt: _start,
            endedAt: _end,
            thumbnail: _thumbnail,
          ),
          token: token,
        );
        return [
          'Nama pengalaman: ${saved.title}',
          'Organisasi: ${saved.organization}',
          'Deskripsi: ${saved.description}',
          'Kategori: ${saved.categoryLabel}',
          'Mulai: ${saved.startedAt}',
          'Selesai: ${saved.endedAt ?? "Masih berlangsung"}',
        ];
      },
    );
  }
}
