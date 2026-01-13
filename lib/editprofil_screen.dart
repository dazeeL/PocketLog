import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilScreen extends StatefulWidget {
  final String nama;
  final String username;
  final String email;
  final String password;
  final Function(String, String, String, String) onSave;

  const EditProfilScreen({
    super.key,
    required this.nama,
    required this.username,
    required this.email,
    required this.password,
    required this.onSave,
  });

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
  }

  Future<void> _simpanPerubahan() async {
    setState(() => isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User belum login");
      }

      await supabase.from('profiles').update({
        'nama': namaController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      }).eq('id', userId);

      widget.onSave(
        namaController.text,
        emailController.text,
        "",
        usernameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update profil: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9CBD2),
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE47990),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            _buildLabel("Nama Lengkap"),
            _buildTextField(namaController, "Masukkan nama"),

            const SizedBox(height: 16),

            _buildLabel("Username"),
            _buildTextField(usernameController, "Masukkan username"),

            const SizedBox(height: 16),

            _buildLabel("Email"),
            _buildTextField(emailController, "Masukkan email"),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _simpanPerubahan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8445E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFB8445E),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: const Color(0xFFF2B8C2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
