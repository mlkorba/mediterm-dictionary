import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Dark Overlay
          Image.asset(
            'assets/vintage-anatomy.jpg', // Replace with your image asset
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MediTerm Dictionary',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalDictionary(),
                      ),
                    );
                  },
                  child: const Text('Let\'s Go'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
