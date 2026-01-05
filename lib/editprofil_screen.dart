import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profil_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // buat kIsWeb

class EditProfilScreen extends StatefulWidget {
  final String nama;
  final String password;
  final String email;
  final String username;
  final Function(String, String, String, String) onSave;

  const EditProfilScreen({
    super.key,
    this.nama = '',
    this.username = '',
    this.password = '',
    this.email = '',
    this.onSave = _dummyOnSave,
  });

  static void _dummyOnSave(String a, String b, String c, String d) {}

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  Uint8List? _webImage; // buat web
  XFile? _pickedFile; // bisa dipakai di semua platform
  final ImagePicker _picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // kalau di web, ubah jadi bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _pickedFile = pickedFile;
        });
      } else {
        // kalau di android/ios, langsung simpen file
        setState(() {
          _pickedFile = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 98, 146, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),

                  // FOTO PROFIL
                  Center(     
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _webImage != null
                              ? MemoryImage(_webImage!)
                              : _pickedFile != null
                                  ? Image.network(_pickedFile!.path).image
                                  : const AssetImage('asset/mingyu.jpeg')
                                      as ImageProvider,
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.camera_alt,
                                  color: Color(0xFF3B3DBF), size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildTextField("Nama", namaController),
                  const SizedBox(height: 16),
                  _buildTextField("Username", usernameController),
                  const SizedBox(height: 16),
                  _buildTextField("Email", emailController),
                  const SizedBox(height: 16),
                  _buildTextField("Password", passwordController),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // ==================== FLOATING BUTTON ====================
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    child: const Text("Cancel",
                    
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
  widget.onSave(
    namaController.text,
    emailController.text,
    usernameController.text,
    passwordController.text,
  );
  Navigator.pop(context); // balik

},



                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 248, 126, 167),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.rubik(
            color: Colors.white70,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 248, 126, 167),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
