import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'halaman_tambah_pemasukan.dart';
import 'halaman_tambah_transaksi.dart';
import 'halaman_pengingat.dart';
import 'profil_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final supabase = Supabase.instance.client;

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color cardColor = const Color(0xFFF5F6FA);

  int _currentIndex = 0;

  // ===== DATA USER =====
  String? namaUser;
  bool isLoadingNama = true;

  // ===== DATA UANG =====
  int saldo = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;

  // ===== DATA PIE CHART =====
  Map<String, double> grafikData = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadGrafikData();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('profiles')
        .select('nama')
        .eq('id', user.id)
        .single();

    setState(() {
      namaUser = data['nama'];
      isLoadingNama = false;
    });
  }

  // ================= LOAD PEMASUKAN & PENGELUARAN =================
  Future<void> _loadGrafikData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // ===== Load pemasukan =====
    final pemasukanResp = await supabase
        .from('pemasukan')
        .select()
        .eq('user_id', user.id);

    final List<Map<String, dynamic>> pemasukanList =
        List<Map<String, dynamic>>.from(pemasukanResp as List);

    // ===== Load pengeluaran =====
    final pengeluaranResp = await supabase
        .from('transaksi')
        .select()
        .eq('user_id', user.id);

    final List<Map<String, dynamic>> pengeluaranList =
        List<Map<String, dynamic>>.from(pengeluaranResp as List);

    // ===== Hitung total dan kategori pengeluaran =====
    int pemasukanTemp = 0;
    int pengeluaranTemp = 0;
    Map<String, double> tempMap = {};

    for (var p in pemasukanList) {
      pemasukanTemp += p['jumlah'] as int;
    }

    for (var t in pengeluaranList) {
      final jumlah = t['jumlah'] as int;
      pengeluaranTemp += jumlah;
      final kategori = t['kategori'] ?? 'Lainnya';
      tempMap[kategori] = (tempMap[kategori] ?? 0) + jumlah.toDouble();
    }

    if (!mounted) return;
    setState(() {
      totalPemasukan = pemasukanTemp;
      totalPengeluaran = pengeluaranTemp;
      saldo = totalPemasukan - totalPengeluaran;
      grafikData = tempMap;
    });
  }

  // ================= COLOR CHART =================
  Color _getColor(String kategori) {
    switch (kategori) {
      case "Makanan":
        return Colors.redAccent;
      case "Transportasi":
        return Colors.orangeAccent;
      case "Belanja":
        return Colors.blueAccent;
      case "Tagihan":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(),
      const HalamanPengingat(),
      HalamanGrafikSupabase(
        supabase: supabase,
        getColor: _getColor,
      ),
      const ProfilScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 2) _loadGrafikData();
        },
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
              isLoadingNama
                  ? const Text(
                      "Loading...",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      namaUser ?? "User",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
            child: _buildPieChartHome(),
          ),
        ],
      ),
    );
  }

  // ================= PEMASUKAN BOX =================
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
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HalamanTambahPemasukan()),
                  );

                  if (result == true) {
                    await _loadGrafikData();
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

  // ================= PENGELUARAN BOX =================
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
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HalamanTambahTransaksi()),
                  );

                  if (result == true) {
                    await _loadGrafikData();
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red,
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

  // ================= PIE CHART =================
  Widget _buildPieChartHome() {
    if (grafikData.isEmpty) {
      return const Center(child: Text("Belum ada transaksi"));
    }

    final sections = grafikData.entries.map((entry) {
      final value = entry.value;
      final percent = value /
          (grafikData.values.fold(0.0, (sum, element) => sum + element)) *
          100;
      return PieChartSectionData(
        value: value,
        title: "${percent.toStringAsFixed(0)}%",
        color: _getColor(entry.key),
        radius: 70,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        centerSpaceRadius: 55,
        sectionsSpace: 4,
        sections: sections,
      ),
    );
  }
}

// ================= HALAMAN GRAFIK SUPABASE =================
class HalamanGrafikSupabase extends StatefulWidget {
  final SupabaseClient supabase;
  final Color Function(String) getColor;

  const HalamanGrafikSupabase({
    super.key,
    required this.supabase,
    required this.getColor,
  });

  @override
  State<HalamanGrafikSupabase> createState() => _HalamanGrafikSupabaseState();
}

class _HalamanGrafikSupabaseState extends State<HalamanGrafikSupabase> {
  Map<String, double> grafikData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrafik();
  }

  Future<void> _loadGrafik() async {
    final user = widget.supabase.auth.currentUser;
    if (user == null) return;

    final response = await widget.supabase
        .from('transaksi')
        .select()
        .eq('user_id', user.id);

    final List<Map<String, dynamic>> transaksiList =
        List<Map<String, dynamic>>.from(response as List);

    Map<String, double> tempMap = {};

    for (var trx in transaksiList) {
      final kategori = trx['kategori'] ?? 'Lainnya';
      final jumlah = (trx['jumlah'] as int).toDouble();
      tempMap[kategori] = (tempMap[kategori] ?? 0) + jumlah;
    }

    setState(() {
      grafikData = tempMap;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (grafikData.isEmpty) {
      return const Center(child: Text("Belum ada transaksi"));
    }

    final sections = grafikData.entries.map((entry) {
      final value = entry.value;
      final percent = value /
          (grafikData.values.fold(0.0, (sum, element) => sum + element)) *
          100;

      return PieChartSectionData(
        value: value,
        title: "${percent.toStringAsFixed(0)}%",
        color: widget.getColor(entry.key),
        radius: 70,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 55,
          sectionsSpace: 4,
          sections: sections,
        ),
      ),
    );
  }
}
