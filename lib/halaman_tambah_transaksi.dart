import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HalamanTambahTransaksi extends StatefulWidget {
  const HalamanTambahTransaksi({super.key});

  @override
  State<HalamanTambahTransaksi> createState() =>
      _HalamanTambahTransaksiState();
}

class _HalamanTambahTransaksiState extends State<HalamanTambahTransaksi> {
  final Color primaryColor = const Color(0xFFFF5DA2);
  final Color cardColor = const Color(0xFFF5F6FA);

  final jumlahController = TextEditingController();
  final tanggalController = TextEditingController();
  final keteranganController = TextEditingController();

  String? selectedKategori;

  final List<String> kategoriList = [
    "Makanan",
    "Transportasi",
    "Belanja",
    "Tagihan",
    "Lainnya",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("Tambah Transaksi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Jumlah Uang"),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _label("Tanggal"),
              TextField(
                controller: tanggalController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    tanggalController.text =
                        "${date.day}/${date.month}/${date.year}";
                  }
                },
                decoration: InputDecoration(
                  hintText: "Pilih tanggal",
                  suffixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _label("Kategori"),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                items: kategoriList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _label("Keterangan"),
              TextField(
                controller: keteranganController,
                decoration: InputDecoration(
                  hintText: "Contoh: Beli makan siang",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= BUTTON =================
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Transaksi berhasil ditambahkan"),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: primaryColor),
                      ),
                      child: Text(
                        "Batal",
                        style: TextStyle(color: primaryColor),
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

  // ================= HELPER =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
