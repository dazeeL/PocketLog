import 'package:flutter/material.dart';

class HalamanTambahTransaksi extends StatefulWidget {
  const HalamanTambahTransaksi({super.key});

  @override
  State<HalamanTambahTransaksi> createState() => _HalamanTambahTransaksiState();
}

class _HalamanTambahTransaksiState extends State<HalamanTambahTransaksi> {
  String? selectedTanggal;
  String? selectedKategori;

  final jumlahController = TextEditingController();
  final keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 40),
            const Center(
              child: Text(
                "Halaman Tambah Transaksi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // === TANGGAL ===
            Row(
              children: [
                const Text("Tanggal  :  "),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTanggal,
                    items: [
                      "27 April 2025",
                      "28 April 2025",
                      "29 April 2025",
                    ]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedTanggal = value;
                    }),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // === JUMLAH UANG ===
            Row(
              children: [
                const Text("Jumlah uang :  "),
                Expanded(
                  child: TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // === KATEGORI ===
            Row(
              children: [
                const Text("Kategori :  "),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedKategori,
                    items: ["Makanan", "Transportasi", "Belanja", "Lainnya"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedKategori = value;
                    }),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // === KETERANGAN ===
            Row(
              children: [
                const Text("Keterangan :  "),
                Expanded(
                  child: TextField(
                    controller: keteranganController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 40),

            // === BUTTON SIMPAN & BATAL ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Transaksi berhasil ditambahkan!")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan"),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
