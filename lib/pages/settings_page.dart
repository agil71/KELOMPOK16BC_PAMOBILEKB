import 'package:flutter/material.dart';
import 'profile_page.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SettingsPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.settings),
          //   onPressed: () {
          //     // Aksi jika ada pengaturan di sini
          //   },
          // ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.blue,
                    ),
                    title: Text(
                      isDarkMode ? "Switch Mode" : "Switch Mode",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: toggleTheme,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text("Profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}