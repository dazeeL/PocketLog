import 'package:flutter/material.dart';
import 'halaman_tambah_pengingat.dart';

class HalamanPengingat extends StatefulWidget {
  const HalamanPengingat({super.key});

  @override
  State<HalamanPengingat> createState() => _HalamanPengingatState();
}

class _HalamanPengingatState extends State<HalamanPengingat> {
  bool contohChecked = false; // checkbox contoh

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB), // pink soft background

      body: Column(
        children: [
          const SizedBox(height: 40),

          // ================= HEADER ==================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // icon kiri dummy
                const Icon(Icons.brightness_1, size: 40, color: Colors.black54),

                const Text(
                  "Pengingat",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ==== FOTO PROFIL USER ====
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.pink.shade200,
                  backgroundImage: const NetworkImage(
                    "https://i.pravatar.cc/300", // nanti kamu ganti ke foto user
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ============ CARD CONTOH FORM (Nama tagihan, Jumlah, Tanggal) ============
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // isi kolom
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Nama tagihan", style: TextStyle(fontSize: 15)),
                      SizedBox(height: 6),
                      Text("Jumlah", style: TextStyle(fontSize: 15)),
                      SizedBox(height: 6),
                      Text("Tanggal", style: TextStyle(fontSize: 15)),
                    ],
                  ),

                  // checkbox bisa ditekan
                  Checkbox(
                    value: contohChecked,
                    onChanged: (value) {
                      setState(() => contohChecked = value!);
                    },
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= LIST ITEM PENGINGAT =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // ==== Card pengingat ====
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // informasi tagihan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Listrik Kontrakan",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text("Rp 200.000",
                              style: TextStyle(color: Colors.black87)),
                          Text("28 April 2025",
                              style: TextStyle(color: Colors.black87)),
                        ],
                      ),

                      // checkbox
                      const Icon(Icons.check_box_outline_blank),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ================= TOMBOL TAMBAH =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HalamanTambahPengingat()),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink.shade400,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
