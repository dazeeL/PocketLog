import 'package:flutter/material.dart';
import 'halaman_tambah_pengingat.dart';

class HalamanPengingat extends StatelessWidget {
  const HalamanPengingat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // === HEADER TANPA APPBAR (sesuai wireframe) ===
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Row: Icon kiri + Judul + Icon profil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.circle, size: 40), // Dummy icon kiri sesuai sketsa
                Text(
                  "Pengingat",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.person, size: 40),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // === CONTAINER FORM KECIL (Nama tagihan, Jumlah, Tanggal) ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Nama tagihan"),
                  SizedBox(height: 6),
                  Text("Jumlah"),
                  SizedBox(height: 6),
                  Text("Tanggal"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // === LIST ITEM PENGINGAT ===
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Info tagihan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Listrik Kontrakan",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Rp 200.000"),
                          Text("28 April 2025"),
                        ],
                      ),
                      // Checkbox kosong
                      const Icon(Icons.check_box_outline_blank),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // === FLOATING BUTTON TAMBAH (+) ===
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HalamanTambahPengingat()),
          );
        },
        child: const Icon(Icons.add),
      ),

      // === BOTTOM NAVIGATION (sesuai sketsa) ===
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
