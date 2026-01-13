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
  final ImagePicker picker = ImagePicker();

  String nama = "";
  String username = "";
  String email = "";
  String? avatarUrl;

  bool isLoading = true;
  bool isUploading = false;

  // ===== PALET WARNA =====
  final Color primaryPink = const Color(0xFFF48FB1);
  final Color softBg = const Color(0xFFFFFBFD);
  final Color cardBg = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

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
      debugPrint("Load profile error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile == null) return;

    setState(() => isUploading = true);

    final filePath = '${user.id}/avatar.jpg';

    try {
      final bytes = await pickedFile.readAsBytes();

      await supabase.storage.from('avatars').uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      final publicUrl =
          supabase.storage.from('avatars').getPublicUrl(filePath);

      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      setState(() => avatarUrl = publicUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Avatar berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Upload avatar error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal upload avatar"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

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
      backgroundColor: softBg,
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
                  decoration: BoxDecoration(
                    color: primaryPink,
                    borderRadius: const BorderRadius.vertical(
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
                        onTap: isUploading ? null : _pickAvatar,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (avatarUrl != null && avatarUrl!.isNotEmpty)
                                      ? NetworkImage(avatarUrl!)
                                      : null,
                              child: (avatarUrl == null ||
                                      avatarUrl!.isEmpty)
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.grey)
                                  : null,
                            ),
                            if (isUploading)
                              const CircularProgressIndicator(),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: primaryPink,
                                ),
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
                                  backgroundColor: const Color(0xFFA65C73),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
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
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13)),
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
            const Icon(Icons.arrow_forward_ios,
                color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
