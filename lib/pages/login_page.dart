import 'package:flutter/material.dart';
import 'main_page.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  LoginPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       isDarkMode ? Icons.light_mode : Icons.dark_mode,
        //       color: Colors.white,
        //     ),
        //     onPressed: toggleTheme,
        //   ),
        // ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Username',
                  controller: usernameController,
                ),
                CustomTextField(
                  labelText: 'Password',
                  controller: passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    // Validasi input
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      // Tampilkan pesan error jika ada input kosong
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Username dan Password harus diisi!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Jika validasi berhasil, lanjutkan ke MainPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            toggleTheme: toggleTheme,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      );
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
