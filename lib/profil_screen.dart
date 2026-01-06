import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'editprofil_screen.dart';
import 'halaman_login.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final supabase = Supabase.instance.client;
  final picker = ImagePicker();

  String nama = "";
  String username = "";
  String email = "";
  String? avatarUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ===== LOAD PROFILE =====
  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        nama = data['nama'] ?? "";
        username = data['username'] ?? "";
        email = data['email'] ?? user.email ?? "";
        avatarUrl = data['avatar_url'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error load profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAvatar() async {
  final user = supabase.auth.currentUser;
  if (user == null) return;

  // Pilih file dari galeri
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
  );

  if (picked == null) return;

  final file = File(picked.path);
  final filePath = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  try {
    // Upload ke Supabase Storage
    await supabase.storage.from('avatars').upload(
      filePath,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    // Ambil public URL
    final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

    // Update profiles.avatar_url
    final response = await supabase
        .from('profiles')
        .update({'avatar_url': publicUrl})
        .eq('id', user.id);

    if (response.error != null) {
      print("Error updating profile: ${response.error!.message}");
      return;
    }

    // Update UI
    setState(() => avatarUrl = publicUrl);
  } catch (e) {
    print("Upload error: $e");
  }
}


  // ===== LOGOUT =====
  Future<void> _logout() async {
    await supabase.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HalamanLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: GoogleFonts.rubik(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilScreen(
                    nama: nama,
                    username: username,
                    email: email,
                    password: "",
                    onSave: (n, e, p, u) {
                      setState(() {
                        nama = n;
                        email = e;
                        username = u;
                      });
                    },
                  ),
                ),
              );
              _loadProfile();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 56, 171),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // ===== AVATAR =====
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
  radius: 60,
  backgroundColor: Colors.white,
  backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
      ? NetworkImage(avatarUrl!)
      : null,
  child: avatarUrl == null || avatarUrl!.isEmpty
      ? const Icon(Icons.person, size: 60, color: Colors.grey)
      : null,
),


                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    size: 20, color: Color(0xFF002E9D)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        nama,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            profilCard("Username", username),
                            profilCard("Email", email),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _logout,
                                icon: const Icon(Icons.logout),
                                label: const Text("Logout"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

 Widget profilCard(String title, String value) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
}