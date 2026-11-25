import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import 'portofolio_navigation.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    final pageContext = Scaffold.of(context).context;

    Widget tile(String label, IconData icon, String action) {
      return ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: () {
          Navigator.of(context).pop();
          openPortfolioMenu(pageContext, action);
        },
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text(
              'My Portfolio',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.popUntil((route) => route.isFirst);
            },
          ),
          tile('Lihat Proyek', Icons.folder, 'Lihat Proyek'),
          tile('Add Project', Icons.create_new_folder_outlined, 'Tambah Proyek'),
          tile('Lihat Pengalaman', Icons.work, 'Lihat Pengalaman'),
          tile('Add Experience', Icons.post_add, 'Tambah Pengalaman'),
          tile(
            loggedIn ? 'Logout' : 'Login',
            loggedIn ? Icons.logout : Icons.login,
            loggedIn ? 'Logout' : 'Login',
          ),
        ],
      ),
    );
  }
}
