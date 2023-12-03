import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMedicalCard(
              title: 'Human Anatomy',
              description: 'Explore the detailed anatomy of the human body.',
              imageAsset: 'assets/anatomy.jpg', // Replace with your image asset
              onTap: () {
                // Navigate to the corresponding screen or perform an action
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => AnatomyScreen()));
              },
            ),
            const SizedBox(height: 16),
            _buildMedicalCard(
              title: 'Medical Dictionary',
              description: 'Search and learn about medical terms.',
              imageAsset:
                  'assets/dictionary.jpg', // Replace with your image asset
              onTap: () {
                // Navigate to the Medical Dictionary screen
              },
            ),
            // Add more cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalCard({
    required String title,
    required String description,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              imageAsset,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
