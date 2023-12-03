import 'package:flutter/material.dart';
import 'views/medical_dictionary.dart';
// import 'views/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MedicalDictionary(),
    );
  }
}
