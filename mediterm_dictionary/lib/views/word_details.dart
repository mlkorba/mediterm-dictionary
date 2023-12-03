import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';

class WordDetailPage extends StatelessWidget {
  final Definition definition;

  const WordDetailPage({Key? key, required this.definition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(definition.term),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Definition:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(definition.definition),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
