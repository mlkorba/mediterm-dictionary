import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/reusable_widgets/reusable_widgets.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';
import 'package:mediterm_dictionary/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/vintage-anatomy.jpg'), // Replace with your image asset
                fit: BoxFit.cover, // Adjust as needed
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.25,
                20,
                0,
              ),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/medical-icon.png"),
                  const SizedBox(
                    height: 50,
                  ),
                  reusableTextField("Email Address", Icons.email, false,
                      _emailTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField(
                      "Password", Icons.lock, true, _passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  loginSignUpButton(context, true, () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Login Successful");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MedicalDictionary()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  }),
                  signUpOption()
                ],
              ),
            ), // Padding
          ), // SingleChildScrollView
        ],
      ),
    );
  }
