import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'halaman_tambah_transaksi.dart';

class HalamanGrafik extends StatelessWidget {
  const HalamanGrafik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      appBar: AppBar(
        title: const Text("Grafik Pengeluaran"),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ================= PIE CHART =================
              SizedBox(
                height: 240, // LEBIH AMAN
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 55,
                    sectionsSpace: 4,
                    sections: [
                      PieChartSectionData(
                        value: 50,
                        color: Colors.redAccent,
                        title: '',
                        radius: 75,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Colors.orangeAccent,
                        title: '',
                        radius: 70,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.blueAccent,
                        title: '',
                        radius: 65,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= LEGEND =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    LegendItem(color: Colors.redAccent, text: " • "),
                    LegendItem(color: Colors.orangeAccent, text: " • "),
                    LegendItem(color: Colors.blueAccent, text: " • "),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= BUTTON =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HalamanTambahTransaksi(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Transaksi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= LEGEND ITEM =================
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
