import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'halaman_awal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cjupmuenlbfbvdiojkzl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqdXBtdWVubGJmYnZkaW9qa3psIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3NDUwODQsImV4cCI6MjA4MjMyMTA4NH0.h2tCMY9V_BRsK_QbACFT5ulM-C3PW-0O95jOPhkDUKk',
  );

  runApp(const PocketLogApp());
}

class PocketLogApp extends StatelessWidget {
  const PocketLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketLog',

      theme: ThemeData(
        // ===== WARNA UTAMA =====
        primaryColor: const Color(0xFFF48FB1),
        scaffoldBackgroundColor: const Color(0xFFFFFBFD),

        // ===== APPBAR =====
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF48FB1),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // ===== ELEVATED BUTTON =====
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF48FB1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        // ===== FLOATING BUTTON =====
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF48FB1),
          foregroundColor: Colors.white,
        ),

        // ===== CHECKBOX =====
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFFF48FB1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // ===== INPUT =====
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFF1F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      home: const HalamanAwal(),
    );
  }
}
