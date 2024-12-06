import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyimpan apakah dark mode aktif
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.OQmZ2bd64svR2SMjHPByTQHaHa?w=181&h=181&c=7&r=0&o=5&pid=1.7'),
                      backgroundColor: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Email: anonymous@gmail.com',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: isDarkMode ? Colors.white : Colors.blue),
                        title: Text('Nama Lengkap'),
                        subtitle: Text('-'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone, color: isDarkMode ? Colors.white : Colors.blue),
                        title: Text('Nim'),
                        subtitle: Text('-'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.location_on, color: isDarkMode ? Colors.white : Colors.blue),
                        title: Text('Nomor Telepon'),
                        subtitle: Text('-'),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //     textStyle: const TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   child: const Text("Kembali"),
              // ),
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
    );
  }
} 