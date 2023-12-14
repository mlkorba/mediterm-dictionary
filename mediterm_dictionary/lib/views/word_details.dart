import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/bookmark_list.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';

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
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Sign Out Successful");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Stack(
          children: [
          // Positioned Container (Gradient)
          Positioned(
            top: 149,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, Colors.red],
                ),
              ),
                    ),
          ),

          // Positioned Container (Card for definition)
          Positioned(
            top: 150, // Adjust the value as needed to move it up or down
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                        color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
              ),
            ),
              child: Padding(
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.home, color: Colors.white),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(
            //       context,
            //       '/medical_dictionary',
            //     ); // Navigate to MedicalDictionary
            //   },
            // ),
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

  // String cleanUpDefinition(String input) {
  //   final result =
  //       RegExp(r'\{bc\}(.+?)\]').firstMatch(input)?.group(1)?.trim() ?? '';
  //   return result;
  // }

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
            fontSize: 16,
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
