import 'package:flutter/material.dart';

class HalamanTambahTransaksi extends StatelessWidget {
  const HalamanTambahTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final nominalController = TextEditingController();
    final kategoriController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal'),
            ),
            TextField(
              controller: kategoriController,
              decoration: const InputDecoration(labelText: 'Kategori (contoh: Makanan, Transportasi)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaksi berhasil ditambahkan!')),
                );
                Navigator.pop(context);
              },
              child: const Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }
}
