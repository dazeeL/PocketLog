import 'package:flutter/material.dart';
import 'halaman_tambah_pemasukan.dart';
import 'halaman_pengingat.dart';
import 'halaman_grafik.dart';
import 'profil_screen.dart';

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PocketLog')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Saldo: Rp 300.000', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Pemasukan'),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HalamanTambahPemasukan()));
                },
              ),
              ElevatedButton(
                child: const Text('Pengingat'),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HalamanPengingat()));
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Grafik'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalamanGrafik()));
          } else if (index == 2) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalamanProfil()));
          }
        },
      ),
    );
  }
}
