import 'package:flutter/material.dart';
import 'views/home.dart';
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
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
