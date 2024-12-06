import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class MainPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  MainPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController pendapatanController = TextEditingController();

  String selectedTempatTinggal = '';
  String selectedPekerjaanOrtu = '';
  String selectedKendaraan = '';
  String uktResult = '';

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    pendapatanController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void classifyUKT() {
    // Validasi NIM
    if (nimController.text.isEmpty || int.tryParse(nimController.text) == null) {
      showError('NIM dan Penghasilan Ortu harus berupa angka');
      return;
    }

    // Validasi Penghasilan Orang Tua
    double pendapatan = double.tryParse(pendapatanController.text) ?? -1;
    if (pendapatan < 0) {
      showError('NIM dan Penghasilan Ortu harus berupa angka');
      return;
    }

    // Klasifikasi berdasarkan kriteria yang disebutkan
    if (selectedTempatTinggal == 'Desa' || selectedPekerjaanOrtu == 'Nelayan' || selectedPekerjaanOrtu == 'Petani') {
      if (pendapatan < 3000000 || selectedKendaraan == 'Tidak Ada') {
        setState(() {
          uktResult = 'Layak Mendapatkan Keringanan UKT';
        });
      } else {
        setState(() {
          uktResult = 'Tidak Layak Mendapatkan Keringanan UKT';
        });
      }
    } else if (selectedTempatTinggal == 'Kota' && pendapatan < 5000000 && selectedKendaraan == 'Satu') {
      setState(() {
        uktResult = 'Layak Mendapatkan Keringanan UKT';
      });
    } else if (pendapatan < 5000000 || selectedKendaraan == 'Tidak Ada') {
      setState(() {
        uktResult = 'Layak Mendapatkan Keringanan UKT';
      });
    } else {
      setState(() {
        uktResult = 'Tidak Layak Mendapatkan Keringanan UKT';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildMainPageContent();  // Halaman Home/MainPage
      case 1:
        return SettingsPage(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode);  // Settings
      case 2:
        return ProfilePage();  // Profile
      default:
        return _buildMainPageContent();
    }
  }

  Widget _buildMainPageContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Klasifikasi Keringanan UKT Mahasiswa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Mahasiswa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Nama Mahasiswa',
                      controller: namaController,
                    ),
                    CustomTextField(
                      labelText: 'NIM',
                      controller: nimController,
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tempat Tinggal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedTempatTinggal.isEmpty ? null : selectedTempatTinggal,
                      items: [
                        DropdownMenuItem(
                          value: 'Kota',
                          child: Text('Kota'),
                        ),
                        DropdownMenuItem(
                          value: 'Desa',
                          child: Text('Desa'),
                        ),
                        DropdownMenuItem(
                          value: 'Lainnya',
                          child: Text('Lainnya'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedTempatTinggal = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Pekerjaan Orang Tua',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedPekerjaanOrtu.isEmpty ? null : selectedPekerjaanOrtu,
                      items: [
                        DropdownMenuItem(
                          value: 'PNS',
                          child: Text('PNS'),
                        ),
                        DropdownMenuItem(
                          value: 'TNI / POLRI',
                          child: Text('TNI / POLRI'),
                        ),
                        DropdownMenuItem(
                          value: 'Nelayan',
                          child: Text('Nelayan'),
                        ),
                        DropdownMenuItem(
                          value: 'Petani',
                          child: Text('Petani'),
                        ),
                        DropdownMenuItem(
                          value: 'Buruh',
                          child: Text('Buruh'),
                        ),
                        DropdownMenuItem(
                          value: 'Guru',
                          child: Text('Guru'),
                        ),
                        DropdownMenuItem(
                          value: 'Ibu Rumah Tangga',
                          child: Text('Ibu Rumah Tangga'),
                        ),
                        DropdownMenuItem(
                          value: 'Wiraswasta',
                          child: Text('Wiraswasta'),
                        ),
                        DropdownMenuItem(
                          value: 'Lainnya',
                          child: Text('Lainnya'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPekerjaanOrtu = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Penghasilan Orang Tua',
                      controller: pendapatanController,
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Jumlah Kendaraan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedKendaraan.isEmpty ? null : selectedKendaraan,
                      items: [
                        DropdownMenuItem(
                          value: 'Tidak Ada',
                          child: Text('Tidak Ada'),
                        ),
                        DropdownMenuItem(
                          value: 'Satu',
                          child: Text('Satu'),
                        ),
                        DropdownMenuItem(
                          value: 'Dua',
                          child: Text('Dua'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedKendaraan = value!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'Klasifikasikan Keringanan UKT',
                      onPressed: classifyUKT,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Hasil Klasifikasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      uktResult.isEmpty ? 'Belum diklasifikasikan' : uktResult,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: uktResult.contains('Layak') ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klasifikasi Keringanan UKT Mahasiswa'),
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
