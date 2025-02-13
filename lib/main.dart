import 'package:crypto_app/home_screen.dart';
import 'package:crypto_app/load_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
