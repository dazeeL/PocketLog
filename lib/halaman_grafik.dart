import 'package:flutter/material.dart';
import 'halaman_tambah_transaksi.dart';

class HalamanGrafik extends StatelessWidget {
  const HalamanGrafik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grafik Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.pie_chart, size: 120, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Makan - 40%\nKendaraan - 30%\nBelanja - 30%'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanTambahTransaksi()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
