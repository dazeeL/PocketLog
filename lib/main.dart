import 'package:flutter/material.dart';
import 'package:flutter_application_1/halaman_daftar.dart';
import 'package:flutter_application_1/halaman_login.dart';
import 'package:flutter_application_1/halaman_pengingat.dart';
import 'editprofil_screen.dart';
import 'profil_screen.dart';

void main() {
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
        primaryColor: Colors.pink[200],

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[300],
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(240, 98, 146, 1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),

      home: const HalamanDaftar(),
    );
  }
}
