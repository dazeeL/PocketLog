import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'halaman_tambah_pengingat.dart';

class HalamanPengingat extends StatefulWidget {
  const HalamanPengingat({super.key});

  @override
  State<HalamanPengingat> createState() => _HalamanPengingatState();
}

class _HalamanPengingatState extends State<HalamanPengingat> {
  final supabase = Supabase.instance.client;

  // ===== PALET POCKETLOG =====
  final Color primaryColor = const Color(0xFFE47990);
  final Color bgColor = const Color(0xFFF9CBD2);
  final Color cardColor = const Color(0xFFFFF7FA);
  final Color accentColor = const Color(0xFFB8445E);

  List<Map<String, dynamic>> pengingatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPengingat();
  }

  Future<void> _loadPengingat() async {
    setState(() => isLoading = true);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await supabase
          .from('pengingat')
          .select()
          .eq('user_id', userId)
          .order('tanggal', ascending: true);

      setState(() {
        pengingatList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error load pengingat: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Pengingat",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A3A),
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

            // ===== LIST =====
            Expanded(
              child: isLoading
                  ? CircularProgressIndicator(color: primaryColor)
                  : pengingatList.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada pengingat",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: pengingatList.length,
                          itemBuilder: (context, index) {
                            final item = pengingatList[index];
                            final tanggal = DateTime.parse(item['tanggal']);
                            bool checked = item['is_done'] ?? false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['nama_tagihan'] ?? "-",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Rp ${item['jumlah'] ?? 0}",
                                            style: TextStyle(
                                              color: accentColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "${tanggal.day}/${tanggal.month}/${tanggal.year}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: checked,
                                      activeColor: primaryColor,
                                      checkColor: Colors.white,
                                      onChanged: (value) async {
                                        await supabase
                                            .from('pengingat')
                                            .update({'is_done': value})
                                            .eq('id', item['id']);
                                        _loadPengingat();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),

      // ===== FAB =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HalamanTambahPengingat(),
            ),
          );

          if (result == true) _loadPengingat();
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
