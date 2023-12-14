import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/bookmark_list.dart';

class WordDetailPage extends StatelessWidget {
  final Definition definition;
  final bool isBookmarked;
  final List<Definition> bookmarkedDefinitions;

  const WordDetailPage({
    super.key,
    required this.definition,
    required this.isBookmarked,
    required this.bookmarkedDefinitions,
  });

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
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      definition.id,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                        fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  HwiWidget(hwi: definition.hwi),
                    IconButton(
                      icon: Icon(
                        // Icons.bookmark_border,
                        color: Colors.white,
                        bookmarkedDefinitions.contains(definition)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        // setState(() {
                        //   if (bookmarkedDefinitions.contains(term)) {
                        //     bookmarkedDefinitions.remove(term);
                        //   } else {
                        //     bookmarkedDefinitions.add(term);
                        //   }
                        // });
                      },
                    ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/medical_dictionary',
                ); // Navigate to MedicalDictionary
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkListPage(
                      bookmarkedTerms: bookmarkedDefinitions,
                      onUnbookmark: (term) {
                        // setState(() {
                        //   bookmarkedDefinitions.remove(term);
                        // });
                      },
                    ),
                  ),
                ); // Navigate to BookmarkListPage
              },
            ),
          ],
        ),
      ),
    );
  }

  String cleanUpDefinition(String input) {
    return input.replaceAll(RegExp(r'\{bc\}'), '');
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
        Text(
          hwi['hw'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
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
          'DEFINITION:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var definition in def) ...[
          Text(capitalizeFirstWord(cleanUpDefinition(definition.toString()))),
        ],
      ],
    );
  }

  String cleanUpDefinition(String input) {
    String temp =
        RegExp(r'\{bc\}(.+?)\]').firstMatch(input)?.group(1)?.trim() ?? '';
    RegExp pattern = RegExp(r'\{d_link\|([^|]+)\|([^|]+)\}');

    String result = temp.replaceAllMapped(pattern, (match) => match.group(2)!);

    return result;
  }

  String capitalizeFirstWord(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
