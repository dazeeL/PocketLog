import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'halaman_tambah_transaksi.dart';

class HalamanGrafik extends StatefulWidget {
  const HalamanGrafik({super.key});

  @override
  State<HalamanGrafik> createState() => _HalamanGrafikState();
}

class _HalamanGrafikState extends State<HalamanGrafik> {
  final supabase = Supabase.instance.client;

  Map<String, Map<String, dynamic>> kategoriData = {};
  List<Map<String, dynamic>> transaksiList = [];
  double totalPengeluaran = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrafikData();
  }

  // ================= LOAD DATA =================
  Future<void> _loadGrafikData() async {
    setState(() => isLoading = true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data = await supabase
        .from('transaksi')
        .select()
        .eq('user_id', userId)
        .order('tanggal', ascending: false);

    Map<String, Map<String, dynamic>> temp = {};
    double total = 0;

    for (var item in data) {
      final String kategori = item['kategori'] ?? 'Lainnya';
      final double jumlah = (item['jumlah'] as num).toDouble();

      temp.putIfAbsent(kategori, () => {
            'total': 0.0,
            'percentage': 0.0,
            'color': _getColor(kategori),
          });

      temp[kategori]!['total'] += jumlah;
      total += jumlah;
    }

    if (total > 0) {
      temp.forEach((key, value) {
        value['percentage'] =
            (value['total'] as double) / total * 100;
      });
    }

    setState(() {
      kategoriData = temp;
      transaksiList = List<Map<String, dynamic>>.from(data);
      totalPengeluaran = total;
      isLoading = false;
    });
  }

  // ================= DELETE =================
  Future<void> _hapusTransaksi(int id) async {
    await supabase.from('transaksi').delete().eq('id', id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaksi berhasil dihapus"),
          backgroundColor: Color(0xFFB8445E),
        ),
      );
    }

    _loadGrafikData();
  }

  void _konfirmasiHapus(int id, String ket) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Transaksi"),
        content: Text("Yakin hapus '$ket'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB8445E),
            ),
            onPressed: () {
              Navigator.pop(context);
              _hapusTransaksi(id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9CBD2),
      appBar: AppBar(
        title: const Text("Grafik Pengeluaran"),
        backgroundColor: const Color(0xFFE47990),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sections: _buildPie(),
                            centerSpaceRadius: 80,
                            sectionsSpace: 3,
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Total"),
                              Text(
                                "Rp${_rupiah(totalPengeluaran.toInt())}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Riwayat Transaksi",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...transaksiList.map(_itemTransaksi).toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Transaksi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE47990),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const HalamanTambahTransaksi(),
                          ),
                        );
                        _loadGrafikData();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ================= ITEM =================
  Widget _itemTransaksi(Map<String, dynamic> t) {
    final int id = t['id'];
    final String kategori = t['kategori'] ?? 'Lainnya';
    final String ket = t['keterangan'] ?? '-';
    final int jumlah = (t['jumlah'] as num).toInt();
    final Color warnaKategori = _getColor(kategori);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8D8DE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: warnaKategori,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ket,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                Text(kategori,
                    style: const TextStyle(color: Colors.grey)),
                Text(
                  "Rp${_rupiah(jumlah)}",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFE47990)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HalamanTambahTransaksi(transaksi: t),
                ),
              );
              _loadGrafikData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color(0xFFB8445E)),
            onPressed: () => _konfirmasiHapus(id, ket),
          ),
        ],
      ),
    );
  }

  // ================= PIE =================
  List<PieChartSectionData> _buildPie() {
    return kategoriData.entries.map((e) {
      return PieChartSectionData(
        value: e.value['percentage'],
        color: e.value['color'],
        radius: 50,
        title: '',
      );
    }).toList();
  }

  // ================= UTIL =================
  String _rupiah(int v) =>
      v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  Color _getColor(String k) {
    switch (k) {
      case 'Makanan':
        return const Color(0xFFF2A1B3);
      case 'Transportasi':
        return const Color(0xFFE47990);
      case 'Belanja':
        return const Color.fromARGB(255, 243, 123, 149);
      case 'Tagihan':
        return const Color(0xFFA65C73);
      default:
        return const Color(0xFFC98A9E);
    }
  }
}
