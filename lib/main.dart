import 'package:flutter/material.dart';
import 'editprofil_screen.dart';

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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EditProfilScreen(), // langsung buka halaman edit profil
    );
  }
}
