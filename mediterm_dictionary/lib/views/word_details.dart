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
              'ID:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(definition.id),
            const SizedBox(height: 8),

            const Text(
              'Stems:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              definition.stems.join(', '), // Join stems without square brackets
            ),

            const SizedBox(height: 8),

            const Text(
              'HWI:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Display 'hwi' using a separate widget
            HwiWidget(hwi: definition.hwi),

            const SizedBox(height: 8),

            const Text(
              'FL:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(definition.fl),

            const SizedBox(height: 8),

            // Display 'DEF' using a separate widget
            DefinitionWidget(def: definition.def),

            if (definition.def.isNotEmpty &&
                definition.def[0]['cats'] != null) ...[
              const SizedBox(height: 8),
              const Text(
                'cat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(cleanUpDefinition(definition.def[0]['cats'].toString())),
            ],

            // Remove 'sound' references from here

            // Add more details as needed
          ],
        ),
      ),
    );
  }

  String cleanUpDefinition(String input) {
    // Replace unwanted symbols or text here
    return input.replaceAll(RegExp(r'\{bc\}'), ''); // Remove {bc}
  }
}

class HwiWidget extends StatelessWidget {
  final Map<String, dynamic> hwi;

  const HwiWidget({Key? key, required this.hwi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('hw: ${hwi['hw']}'),
        // Add additional widgets or formatting as needed for 'hwi'
      ],
    );
  }
}

class DefinitionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> def;

  const DefinitionWidget({Key? key, required this.def}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DEF:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var definition in def) ...[
          Text(cleanUpDefinition(definition.toString())),
        ],
      ],
    );
  }

  String cleanUpDefinition(String input) {
    // Extract text after {bc} and remove leading and trailing whitespaces
    final result =
        RegExp(r'\{bc\}(.+?)\]').firstMatch(input)?.group(1)?.trim() ?? '';

    return result;
  }
}
