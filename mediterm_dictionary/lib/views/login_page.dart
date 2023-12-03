// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'views/login_page.dart'; // Import the new login page
// import 'views/medical_dictionary.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const AuthenticationWrapper(),
//     );
//   }
// }

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator(); // Add a loading indicator if needed
//         } else if (snapshot.hasData) {
//           return const MedicalDictionary();
//         } else {
//           return const LoginPage();
//         }
//       },
//     );
//   }
// }
