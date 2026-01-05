import 'package:flutter/material.dart';
import 'halaman_tambah_pengingat.dart';

class HalamanPengingat extends StatefulWidget {
  const HalamanPengingat({super.key});

  @override
  State<HalamanPengingat> createState() => _HalamanPengingatState();
}

class _HalamanPengingatState extends State<HalamanPengingat> {
  bool contohChecked = false;

  final Color primaryColor = const Color(0xFFFF5DA2);
  final Color bgColor = const Color(0xFFFFF7FB);
  final Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Pengingat",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: Icon(Icons.person, color: primaryColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= CONTOH CARD (SATU-SATUNYA) =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Nama Tagihan",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text("Jumlah"),
                          SizedBox(height: 6),
                          Text("Tanggal"),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: contohChecked,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        setState(() => contohChecked = value!);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HalamanTambahPengingat(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // ================= CARD DECORATION =================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
