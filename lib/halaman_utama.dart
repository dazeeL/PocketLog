import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'halaman_tambah_pemasukan.dart';
import 'halaman_tambah_transaksi.dart';
import 'halaman_pengingat.dart';
import 'halaman_grafik.dart';
import 'profil_screen.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final supabase = Supabase.instance.client;

  // ===== PALETTE POCKETLOG =====
  final Color primaryColor = const Color(0xFFF48FB1); // pink soft
  final Color cardColor = const Color(0xFFFFF1F6); // pink muda
  final Color softGray = const Color(0xFF9E9E9E);

  int _currentIndex = 0;

  String namaUser = "User";
  bool isLoadingNama = true;

  int saldo = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;

  Map<String, double> grafikData = {};
  bool isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadGrafikData();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select('nama')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          namaUser = data['nama'] ?? "User";
          isLoadingNama = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => isLoadingNama = false);
    }
  }

  // ================= LOAD DATA =================
  Future<void> _loadGrafikData() async {
    if (mounted) setState(() => isLoadingData = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final pemasukanResp = await supabase
          .from('pemasukan')
          .select('jumlah')
          .eq('user_id', user.id);

      final pengeluaranResp = await supabase
          .from('transaksi')
          .select('jumlah, kategori')
          .eq('user_id', user.id);

      int pemasukanTemp = 0;
      int pengeluaranTemp = 0;
      Map<String, double> tempMap = {};

      for (var p in pemasukanResp) {
        pemasukanTemp += (p['jumlah'] as int? ?? 0);
      }

      for (var t in pengeluaranResp) {
        final jumlah = t['jumlah'] as int? ?? 0;
        pengeluaranTemp += jumlah;
        final kategori = t['kategori'] ?? 'Lainnya';
        tempMap[kategori] = (tempMap[kategori] ?? 0) + jumlah.toDouble();
      }

      if (mounted) {
        setState(() {
          totalPemasukan = pemasukanTemp;
          totalPengeluaran = pengeluaranTemp;
          saldo = totalPemasukan - totalPengeluaran;
          grafikData = tempMap;
          isLoadingData = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => isLoadingData = false);
    }
  }

// ================= PIE COLOR =================
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
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            _loadProfile();
            _loadGrafikData();
          }
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: softGray,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // ================= HOME =================
  Widget _homeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadProfile();
        await _loadGrafikData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isLoadingNama ? "Loading..." : namaUser,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _loadProfile();
                    _loadGrafikData();
                  },
                )
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

            isLoadingData
                ? const CircularProgressIndicator()
                : Text(
                    "Rp ${_formatRupiah(saldo)}",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
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
            SizedBox(height: 260, child: _buildPieChartHome()),
          ],
        ),
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
            const Icon(Icons.arrow_downward, color: Color(0xFF81C784)),
            const SizedBox(height: 6),
            const Text("Pemasukan",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text("Rp ${_formatRupiah(totalPemasukan)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HalamanTambahPemasukan()),
                  );
                  await _loadGrafikData();
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
            const Icon(Icons.arrow_upward, color: Color(0xFFE57373)),
            const SizedBox(height: 6),
            const Text("Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text("Rp ${_formatRupiah(totalPengeluaran)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HalamanTambahTransaksi()),
                  );
                  await _loadGrafikData();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57373),
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

  Widget _buildPieChartHome() {
    if (grafikData.isEmpty) {
      return const Center(child: Text("Belum ada data"));
    }

    final total =
        grafikData.values.fold(0.0, (sum, element) => sum + element);

    return PieChart(
      PieChartData(
        centerSpaceRadius: 55,
        sectionsSpace: 4,
        sections: grafikData.entries.map((e) {
          final percent = (e.value / total) * 100;
          return PieChartSectionData(
            value: e.value,
            title: "${percent.toStringAsFixed(0)}%",
            color: _getColor(e.key),
            radius: 70,
            titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
