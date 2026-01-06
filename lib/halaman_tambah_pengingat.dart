import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanTambahPengingat extends StatefulWidget {
  const HalamanTambahPengingat({super.key});

  @override
  State<HalamanTambahPengingat> createState() => _HalamanTambahPengingatState();
}

class _HalamanTambahPengingatState extends State<HalamanTambahPengingat> {
  final supabase = Supabase.instance.client;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  DateTime? selectedDate;

  final Color primaryColor = const Color(0xFFFF5DA2);
  final Color bgColor = const Color(0xFFFFF7FB);
  final Color fieldColor = const Color(0xFFFFEEF6);

  Future<void> pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _simpanPengingat() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    if (namaController.text.isEmpty || jumlahController.text.isEmpty || selectedDate == null) return;

    try {
      await supabase.from('pengingat').insert({
        'user_id': user.id,
        'nama_tagihan': namaController.text,
        'jumlah': int.parse(jumlahController.text),
        'tanggal': selectedDate!.toIso8601String(),
        'is_done': false,
      });

      Navigator.pop(context, true); // kirim signal reload
    } catch (e) {
      debugPrint("Error tambah pengingat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("Tambah Pengingat"),
      ),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Nama Tagihan"),
              _textField(controller: namaController, hint: "Contoh: Listrik, Internet"),
              const SizedBox(height: 16),
              _label("Jumlah Uang"),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                  hintText: "0",
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _label("Tanggal"),
              InkWell(
                onTap: pilihTanggal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? "Pilih tanggal"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      Icon(Icons.calendar_today, size: 20, color: primaryColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpanPengingat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text("Batal", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _textField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
