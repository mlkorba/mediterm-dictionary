import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/reusable_widgets/reusable_widgets.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/vintage-anatomy.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Add the black opacity overlay
          Container(
            color: Colors.black
                .withOpacity(0.5), // Set the opacity value as needed
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.2,
                20,
                0,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 125, // Set the size as needed
                    color: Colors.white, // Set the color as needed
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField(
                      "Name", Icons.person, false, _nameTextController),
                  const SizedBox(
                    height: 30,
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
                  loginSignUpButton(context, false, () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Account Creation Successful");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MedicalDictionary()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  })
                ],
              ),
            ), // Padding
          ), // SingleChildScrollView
        ],
      ),
    );
  }
}
