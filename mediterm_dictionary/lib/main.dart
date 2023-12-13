import 'package:flutter/material.dart';
import 'views/home.dart';
import 'views/medical_dictionary.dart';
import 'services/api_service.dart';

final ApiService apiService =
    ApiService('e685bd9f-83a4-429f-bfa1-599dfb152bec');

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Medical Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/medical_dictionary': (context) => const MedicalDictionary(),
        // Add more routes if needed
      },
    );
  }
}
