import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'halaman_login.dart';
import 'halaman_grafik.dart';
import 'halaman_pengingat.dart';
import 'halaman_utama.dart';
import 'editprofil_screen.dart';

class ProfilScreen extends StatefulWidget {
  final String? username;
  const ProfilScreen({super.key, this.username});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String nama = "Sheren Anis";
  String username = "@sherenanis";
  String email = "sheren@example.com";
  String password = "******";
  ImageProvider foto = const AssetImage("asset/as.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 98, 146, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 126, 167),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HalamanUtama()),
            );
          },
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ======== FOTO PROFIL ========
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: foto,
            ),
          ),
          const SizedBox(height: 12),

          // ======== NAMA & USERNAME ========
          Text(
            nama,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          Text(
            username,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),

          // ======== MENU ========
          _buildMenuTile(
            icon: Icons.home,
            title: "Beranda",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanUtama()),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.notifications,
            title: "Pengingat",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanPengingat()),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.pie_chart,
            title: "Grafik",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanGrafik()),
              );
            },
          ),

          // ======== EDIT PROFILE ========
          _buildMenuTile(
            icon: Icons.person,
            title: "Edit Profile",
            onTap: () async {
              // buka halaman edit
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilScreen(
                    nama: nama,
                    username: username,
                    email: email,
                    password: password,
                    onSave: (newNama, newEmail, newUsername, newPassword) {
                      setState(() {
                        nama = newNama;
                        email = newEmail;
                        username = newUsername;
                        password = newPassword;
                      });
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ======== LOGOUT ========
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromRGBO(240, 98, 146, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Keluar'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanLogin()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET LIST TILE CUSTOM BIAR RAPIH
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromRGBO(240, 98, 146, 1)),
        title: Text(title),
        trailing: const Icon(Icons.navigate_next),
        onTap: onTap,
      ),
    );
  }
}
