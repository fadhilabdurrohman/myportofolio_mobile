import 'package:flutter/material.dart';

import '../models/project.dart';
import '../widgets/portofolio_form.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  String _title = '';
  String _description = '';
  int _year = 0;
  String _type = 'Web Development';
  String? _url;
  String? _thumbnail;

  static const types = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return PortfolioForm(
      title: 'Add Project Form',
      successTitle: 'Proyek berhasil ditambahkan!',
      fields: [
        inputField(
          'Nama Proyek',
          validate: (v) => requiredText(v, max: 255),
          save: (v) => _title = cleanText(v!),
        ),
        inputField(
          'Deskripsi Proyek',
          lines: 3,
          validate: (v) => requiredText(v),
          save: (v) => _description = cleanText(v!),
        ),
        inputField(
          'Tahun',
          keyboard: TextInputType.number,
          validate: (v) {
            final year = int.tryParse((v ?? '').trim());
            if (year == null || year < 1900 || year > 2100) {
              return 'Masukkan tahun 1900–2100.';
            }
            return null;
          },
          save: (v) => _year = int.parse(v!.trim()),
        ),
        DropdownButtonFormField<String>(
          initialValue: types.first,
          decoration: const InputDecoration(labelText: 'Kategori Proyek'),
          items: [
            for (final type in types)
              DropdownMenuItem(value: type, child: Text(type)),
          ],
          onChanged: (_) {},
          onSaved: (v) => _type = v!,
        ),
        inputField(
          'Tautan Proyek',
          keyboard: TextInputType.url,
          validate: validateUrl,
          save: (v) => _url = optionalText(v),
        ),
        inputField(
          'URL Gambar',
          keyboard: TextInputType.url,
          validate: validateUrl,
          save: (v) => _thumbnail = optionalText(v),
        ),
      ],
      send: (api, token) async {
        final saved = await api.createProject(
          Project(
            title: _title,
            description: _description,
            year: _year,
            projectType: _type,
            url: _url,
            thumbnail: _thumbnail,
          ),
          token: token,
        );
        return [
          'Nama Proyek: ${saved.title}',
          'Deskripsi: ${saved.description}',
          'Tahun: ${saved.year}',
          'Kategori: ${saved.projectType}',
          if ((saved.url ?? '').isNotEmpty) 'Tautan: ${saved.url}',
        ];
      },
    );
  }
}
