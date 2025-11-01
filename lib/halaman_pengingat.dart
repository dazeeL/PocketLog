import 'package:flutter/material.dart';
import 'halaman_tambah_pengingat.dart';

class HalamanPengingat extends StatelessWidget {
  const HalamanPengingat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengingat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              title: Text('Listrik Kontrakan'),
              subtitle: Text('Rp 200.000 - 4 Juni 2025'),
              trailing: Icon(Icons.check_box_outline_blank),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HalamanTambahPengingat()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
