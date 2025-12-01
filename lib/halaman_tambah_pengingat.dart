import 'package:flutter/material.dart';

class HalamanTambahPengingat extends StatefulWidget {
  const HalamanTambahPengingat({super.key});

  @override
  State<HalamanTambahPengingat> createState() => _HalamanTambahPengingatState();
}

class _HalamanTambahPengingatState extends State<HalamanTambahPengingat> {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController();
  DateTime? selectedDate;

  // UNTUK PICKER TANGGAL
  Future<void> pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "Tambah Pengingat",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // NAMA TAGIHAN
              const Text(
                "Nama Tagihan",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // JUMLAH UANG
              const Text(
                "Jumlah Uang",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.pink[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // TANGGAL
              const Text(
                "Tanggal",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: pilihTanggal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? "Pilih tanggal"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, size: 20, color: Colors.pink),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // BUTTON SIMPAN & BATAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SIMPAN
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // BATAL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.pink),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Colors.pink),
                      ),
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
}
