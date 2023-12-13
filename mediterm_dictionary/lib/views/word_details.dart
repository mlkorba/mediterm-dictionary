import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';

class WordDetailPage extends StatelessWidget {
  final Definition definition;

  const WordDetailPage({Key? key, required this.definition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'MediTerm Dictionary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                capitalize(definition.id),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                  ),
                  const SizedBox(height: 4),
                  HwiWidget(hwi: definition.hwi),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card for definition.def
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                const SizedBox(height: 8),
                DefinitionWidget(def: definition.def),
                if (definition.def.isNotEmpty &&
                    definition.def[0]['cats'] != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'cat:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                            Text(cleanUpDefinition(
                                definition.def[0]['cats'].toString())),
                ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card for definition.stems.join(', ')
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'RELATED TERMS:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            capitalize(definition.stems.join(', ')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card for definition.fl
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'FUNCTIONAL LABEL:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(capitalize(definition.fl)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String cleanUpDefinition(String input) {
    return input.replaceAll(RegExp(r'\{bc\}'), ''); // Remove {bc}
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
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
        Text('hw: ${capitalize(hwi['hw'])}'), // Capitalize the first word in hw
      ],
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
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
    final result =
        RegExp(r'\{bc\}(.+?)\]').firstMatch(input)?.group(1)?.trim() ?? '';
    return result;
  }
}
