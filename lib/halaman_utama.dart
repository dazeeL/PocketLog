import 'package:flutter/material.dart';
import 'halaman_tambah_pemasukan.dart';
import 'halaman_pengingat.dart';
import 'halaman_grafik.dart';
import 'profil_screen.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final Color primaryColor = const Color(0xFF6C63FF);
  final Color cardColor = const Color(0xFFF5F6FA);

  int _currentIndex = 0;

  // ===== DATA UANG =====
  int saldo = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(),
      const HalamanPengingat(),
      const HalamanGrafik(),
      const ProfilScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // ================= HOME CONTENT =================
  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(Icons.person, color: primaryColor),
              ),
              const SizedBox(width: 12),
              const Text(
                "Liuna",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            "Pocket Log",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),

          const Text("Saldo Saat Ini", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            "Rp $saldo",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _pemasukanBox(),
                const SizedBox(width: 12),
                _pengeluaranBox(),
              ],
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            height: 260,
            child: HalamanGrafik(),
          ),
        ],
      ),
    );
  }

  Widget _pemasukanBox() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.arrow_downward, color: Colors.green),
            const SizedBox(height: 6),
            const Text("Pemasukan",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              "Rp $totalPemasukan",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HalamanTambahPemasukan(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      totalPemasukan += result;
                      saldo += result;
                    });
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pengeluaranBox() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.red),
            const SizedBox(height: 6),
            const Text("Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              "Rp $totalPengeluaran",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
