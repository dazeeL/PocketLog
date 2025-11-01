import 'package:flutter/material.dart';
import 'halaman_login.dart';
import 'halaman_daftar.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.savings, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text("Let's get you started", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HalamanDaftar()));
                },
                child: const Text("DAFTAR"),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HalamanLogin()));
                },
                child: const Text("MASUK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
