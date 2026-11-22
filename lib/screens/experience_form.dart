import 'package:flutter/material.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _organization = "";
  String _description = "";
  String _category = "Full-Time";

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
  ];

  String _cleanText(String value) {
    return value.replaceAll(RegExp(r'</?[A-Za-z][^>]*>'), '').trim();
  }

  String? _validateText(String? value, String label, {int? maxLength}) {
    final text = (value ?? '').trim();

    if (_cleanText(text).isEmpty) return "$label wajib diisi.";

    if (maxLength != null && text.runes.length > maxLength) {
      return "$label maksimal $maxLength karaketer.";
    }

    return null;
  }

  // Tampilkan ringkasan yg ditambahkan
  void _showExperienceSummary() {
    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Experience berhasil ditambahkan!"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama pengalaman: ${_cleanText(_title)}'),
                Text('Organisasi: ${_cleanText(_organization)}'),
                Text('Deskripsi: ${_cleanText(_description)}'),
                Text('Kategori: $_category'),
              ]
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _formKey.currentState!.reset();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Experience Form',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama experience
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Experience",
                    labelText: "Nama Experience",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    _title = value;
                  },
                  validator: (value) => _validateText(
                    value, 
                    "Nama Expereince",
                    maxLength: 255,
                  ),
                ),
              ),

              // Organization exp
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama organisasi",
                    labelText: "Nama organisasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    _organization = value;
                  },
                  validator: (value) => _validateText(
                    value, 
                    "Nama organisasi",
                    maxLength: 255,
                  ),
                ),
              ),

              // Description exp
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskirpsi pengalaman",
                    labelText: "Deskripsi pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                  validator: (value) => _validateText(
                    value, 
                    "Deskripsi pengalaman",
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // Tombol simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _showExperienceSummary,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}