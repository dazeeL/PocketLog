import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HalamanTambahPemasukan extends StatefulWidget {
  const HalamanTambahPemasukan({super.key});

  @override
  State<HalamanTambahPemasukan> createState() =>
      _HalamanTambahPemasukanState();
}

class _HalamanTambahPemasukanState extends State<HalamanTambahPemasukan> {
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFFFF5DA2);
  final Color cardColor = const Color(0xFFF5F6FA);

  final jumlahController = TextEditingController();
  final tanggalController = TextEditingController();
  final keteranganController = TextEditingController();

  String? selectedKategori;

  final List<String> kategoriList = [
    "Gaji",
    "Uang Saku",
    "Bonus",
    "Freelance",
    "Usaha",
    "Hadiah",
    "Lainnya",
  ];

  @override
  void dispose() {
    jumlahController.dispose();
    tanggalController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("Tambah Pemasukan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ===== BODY =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Jumlah Uang"),
                _inputField(
                  controller: jumlahController,
                  hint: "0",
                  keyboard: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefixText: "Rp ",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jumlah uang wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _label("Tanggal"),
                _inputField(
                  controller: tanggalController,
                  hint: "dd/mm/yyyy",
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tanggal wajib diisi";
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null) {
                      return "Kategori wajib dipilih";
                    }
                    return null;
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
                _inputField(
                  controller: keteranganController,
                  hint: "Contoh: Gaji / Bonus / dll",
                ),

                const SizedBox(height: 30),

                // ===== BUTTON =====
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                       onPressed: () {
  if (_formKey.currentState!.validate()) {
    final jumlah = int.parse(jumlahController.text);
    Navigator.pop(context, jumlah); // ⬅️ KIRIM NILAI
  }
},

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
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
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }

  // ===== WIDGET BANTU =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
