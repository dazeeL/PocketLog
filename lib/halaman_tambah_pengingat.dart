import 'package:flutter/material.dart';

class HalamanTambahPengingat extends StatelessWidget {
  const HalamanTambahPengingat({super.key});

  @override
  Widget build(BuildContext context) {
    final namaController = TextEditingController();
    final jumlahController = TextEditingController();
    final tanggalController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pengingat')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama tagihan')),
            TextField(controller: jumlahController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah uang')),
            TextField(
              controller: tanggalController,
              decoration: const InputDecoration(labelText: 'Tanggal'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  tanggalController.text =
                      "${picked.day}-${picked.month}-${picked.year}";
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Simpan')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Batal')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
