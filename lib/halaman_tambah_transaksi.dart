import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HalamanTambahTransaksi extends StatefulWidget {
  final Map<String, dynamic>? transaksi;

  const HalamanTambahTransaksi({
    super.key,
    this.transaksi,
  });

  @override
  State<HalamanTambahTransaksi> createState() =>
      _HalamanTambahTransaksiState();
}

class _HalamanTambahTransaksiState extends State<HalamanTambahTransaksi> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  // ===== WARNA BARU =====
  final Color primaryColor = const Color(0xFFB8445E);
  final Color cardColor = const Color(0xFFF6ECFA);

  late TextEditingController jumlahController;
  late TextEditingController tanggalController;
  late TextEditingController keteranganController;

  String? selectedKategori;
  bool isLoading = false;

  final List<String> kategoriList = [
    "Makanan",
    "Transportasi",
    "Belanja",
    "Tagihan",
    "Lainnya",
  ];

  bool get isEdit => widget.transaksi != null;

  @override
  void initState() {
    super.initState();

    jumlahController = TextEditingController(
      text: widget.transaksi?['jumlah'] != null
          ? _formatRupiah(widget.transaksi!['jumlah'].toString())
          : '',
    );

    keteranganController =
        TextEditingController(text: widget.transaksi?['keterangan'] ?? '');

    selectedKategori = widget.transaksi?['kategori'];

    if (widget.transaksi?['tanggal'] != null) {
      final d = DateTime.parse(widget.transaksi!['tanggal']);
      tanggalController =
          TextEditingController(text: "${d.day}/${d.month}/${d.year}");
    } else {
      tanggalController = TextEditingController();
    }
  }

  // ================= SIMPAN =================
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User belum login");

      final p = tanggalController.text.split('/');
      final tanggal =
          '${p[2]}-${p[1].padLeft(2, '0')}-${p[0].padLeft(2, '0')}';

      final jumlahInt =
          int.parse(jumlahController.text.replaceAll('.', ''));

      final data = {
        'jumlah': jumlahInt,
        'tanggal': tanggal,
        'kategori': selectedKategori,
        'keterangan':
            keteranganController.text.isEmpty ? null : keteranganController.text,
      };

      if (isEdit) {
        await supabase
            .from('transaksi')
            .update(data)
            .eq('id', widget.transaksi!['id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Transaksi berhasil diperbarui"),
              backgroundColor: Colors.pink,
            ),
          );
        }
      } else {
        await supabase.from('transaksi').insert({
          'user_id': userId,
          ...data,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Transaksi berhasil ditambahkan"),
              backgroundColor: Colors.pink,
            ),
          );
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    jumlahController.dispose();
    tanggalController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(isEdit ? "Edit Transaksi" : "Tambah Transaksi"),
      ),
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
              children: [
                _fieldJumlah(),
                _fieldTanggal(),
                _fieldKategori(),
                _fieldText("Keterangan", keteranganController),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(isEdit ? "Update" : "Simpan"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= FIELD =================
  Widget _fieldJumlah() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: jumlahController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (v) =>
            v == null || v.isEmpty ? "Jumlah wajib diisi" : null,
        onChanged: (v) {
          final clean = v.replaceAll(RegExp(r'[^0-9]'), '');
          if (clean.isEmpty) return;

          final formatted = _formatRupiah(clean);
          jumlahController.value = TextEditingValue(
            text: formatted,
            selection:
                TextSelection.collapsed(offset: formatted.length),
          );
        },
        decoration: InputDecoration(
          labelText: "Jumlah Pengeluaran",
          prefixText: "Rp ",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _fieldTanggal() {
    return _fieldText(
      "Tanggal",
      tanggalController,
      readOnly: true,
      onTap: _pickDate,
    );
  }

  Widget _fieldKategori() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedKategori,
        items: kategoriList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => selectedKategori = v),
        validator: (v) => v == null ? "Pilih kategori" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _fieldText(
    String label,
    TextEditingController c, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        readOnly: readOnly,
        onTap: onTap,
        validator: (v) =>
            v == null || v.isEmpty ? "$label wajib diisi" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      tanggalController.text = "${d.day}/${d.month}/${d.year}";
    }
  }

  // ================= UTIL =================
  String _formatRupiah(String value) {
    final number = int.parse(value);
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if ((str.length - i) % 3 == 0 && i != 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
