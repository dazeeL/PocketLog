import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'halaman_tambah_pemasukan.dart';
import 'halaman_tambah_transaksi.dart';

class HalamanGrafik extends StatefulWidget {
  const HalamanGrafik({super.key});

  @override
  State<HalamanGrafik> createState() => _HalamanGrafikState();
}

class _HalamanGrafikState extends State<HalamanGrafik> {
  final supabase = Supabase.instance.client;
  Map<String, double> kategoriData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPengeluaran();
  }

  Future<void> _loadPengeluaran() async {
    setState(() => isLoading = true);
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('pengeluaran')
        .select()
        .eq('user_id', user.id);

    Map<String, double> tempData = {};
    for (var item in data) {
      final kategori = item['kategori'] ?? 'Lainnya';
      final jumlah = double.tryParse(item['jumlah'].toString()) ?? 0;
      tempData[kategori] = (tempData[kategori] ?? 0) + jumlah;
    }

    setState(() {
      kategoriData = tempData;
      isLoading = false;
    });
  }

  Color _colorForKategori(String kategori) {
    switch (kategori) {
      case "Makanan":
        return Colors.redAccent;
      case "Transportasi":
        return Colors.orangeAccent;
      case "Belanja":
        return Colors.blueAccent;
      case "Tagihan":
        return Colors.green;
      default:
        return Colors.purpleAccent;
    }
  }

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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Tombol Tambah Pemasukan & Pengeluaran
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Tambah Pemasukan"),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HalamanTambahPemasukan(),
                                ),
                              );
                              if (result == true) {
                                setState(() {}); // Bisa reload data pemasukan kalau mau
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Tambah Pengeluaran"),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HalamanTambahTransaksi(),
                                ),
                              );
                              if (result == true) {
                                _loadPengeluaran(); // reload chart
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Grafik pie
                    if (kategoriData.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Belum ada pengeluaran.\nTambahkan transaksi untuk melihat grafik.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else
                      Column(
                        children: [
                          SizedBox(
                            height: 240,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 55,
                                sectionsSpace: 4,
                                sections: kategoriData.entries.map((e) {
                                  final total = kategoriData.values.reduce((a, b) => a + b);
                                  final percent = (e.value / total * 100).toStringAsFixed(0);
                                  return PieChartSectionData(
                                    value: e.value,
                                    color: _colorForKategori(e.key),
                                    title: "$percent%",
                                    radius: 70,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: kategoriData.entries
                                .map((e) => LegendItem(
                                      color: _colorForKategori(e.key),
                                      text: "${e.key} • ${(e.value / kategoriData.values.reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%",
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Legend
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

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
          Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
