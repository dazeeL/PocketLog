import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'halaman_login.dart';
import 'halaman_daftar.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9CBD2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ===== TITLE =====
              Text(
                "Pocket Log",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB8445E),
                ),
              ),

              const SizedBox(height: 30),

              // ===== BOX LOGO TIMBUL =====
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2B8C2),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB8445E).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    "asset/logo.png",
                    height: 140,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ===== SUBTITLE =====
              Text(
                "Let’s get you started",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE47990),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Kelola keuanganmu dengan mudah",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF8A4A57),
                ),
              ),

              const SizedBox(height: 40),

              // ===== BUTTON DAFTAR =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.trending_up),
                  label: const Text("Daftar"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HalamanDaftar(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE47990),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ===== BUTTON MASUK =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Masuk"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HalamanLogin(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8445E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
