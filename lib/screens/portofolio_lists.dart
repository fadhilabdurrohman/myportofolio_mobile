import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/experience.dart';
import '../models/project.dart';
import '../services/api_client.dart';
import '../widgets/left_drawer.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PortfolioList<Project>(
      title: 'Daftar Proyek',
      emptyMessage: 'Belum ada proyek.',
      load: (api) => api.getProjects(),
      name: (p) => p.title,
      subtitle: (p) => '${p.projectType} · ${p.year}\n${p.description}',
      detail: (p) => _DetailPage(
        title: p.title,
        imageUrl: p.thumbnail,
        fields: {
          'Jenis proyek': p.projectType,
          'Tahun': '${p.year}',
          'Deskripsi': p.description,
          'Tautan proyek': p.url ?? '',
          'Jumlah bintang': '${p.starCount}',
        },
      ),
    );
  }
}

class ExperienceListScreen extends StatelessWidget {
  const ExperienceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PortfolioList<Experience>(
      title: 'Daftar Pengalaman',
      emptyMessage: 'Belum ada pengalaman.',
      load: (api) => api.getExperiences(),
      name: (e) => e.title,
      subtitle: (e) =>
          '${e.organization} · ${e.categoryLabel}\n${e.description}',
      detail: (e) => _DetailPage(
        title: e.title,
        imageUrl: e.thumbnail,
        fields: {
          'Organisasi': e.organization,
          'Kategori': e.categoryLabel,
          'Tanggal mulai': e.startedAt,
          'Tanggal selesai': e.endedAt ?? 'Masih berlangsung',
          'Deskripsi': e.description,
          'Jumlah bintang': '${e.starCount}',
        },
      ),
    );
  }
}

class _PortfolioList<T> extends StatefulWidget {
  const _PortfolioList({
    required this.title,
    required this.emptyMessage,
    required this.load,
    required this.name,
    required this.subtitle,
    required this.detail,
  });

  final String title;
  final String emptyMessage;
  final Future<List<T>> Function(ApiClient) load;
  final String Function(T) name;
  final String Function(T) subtitle;
  final Widget Function(T) detail;

  @override
  State<_PortfolioList<T>> createState() => _PortfolioListState<T>();
}

class _PortfolioListState<T> extends State<_PortfolioList<T>> {
  late Future<List<T>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.load(context.read<ApiClient>());
  }

  Future<void> _reload() async {
    final next = widget.load(context.read<ApiClient>());
    setState(() => _future = next);
    try {
      await next;
    } on Exception {
      // FutureBuilder menampilkan kegagalan dan tombol coba lagi.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<T>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Daftar gagal dimuat. Periksa koneksi ke Django.'),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final rows = snapshot.requireData;
          return RefreshIndicator(
            onRefresh: _reload,
            child: rows.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text(widget.emptyMessage)),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Card(
                        child: ListTile(
                          title: Text(widget.name(row)),
                          subtitle: Text(
                            widget.subtitle(row),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => widget.detail(row),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.title, required this.fields, this.imageUrl});

  final String title;
  final Map<String, String> fields;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl?.trim() ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (image.isNotEmpty)
            Image.network(
              image,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) =>
                  const Text('Gambar tidak dapat dimuat.'),
            ),
          for (final entry in fields.entries)
            if (entry.value.isNotEmpty)
              ListTile(
                title: Text(entry.key),
                subtitle: SelectableText(entry.value),
              ),
        ],
      ),
    );
  }
}
