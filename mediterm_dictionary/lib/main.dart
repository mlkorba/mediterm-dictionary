import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';
import 'package:mediterm_dictionary/services/api_service.dart';

final ApiService apiService =
    ApiService('e685bd9f-83a4-429f-bfa1-599dfb152bec');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDEJuZeSWLTPNj-8mqd-ELQ1w73GPG6XcM',
              appId: '1:921686556422:android:4afe551619c1c174806887',
              messagingSenderId: '921686556422',
              projectId: 'mediterm-dictionary'))
      : await Firebase.initializeApp();
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
