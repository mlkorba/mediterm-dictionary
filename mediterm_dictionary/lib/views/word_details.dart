// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/reusable_widgets/reusable_widgets.dart';
import 'package:mediterm_dictionary/views/bookmark_list.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';

class WordDetailPage extends StatefulWidget {
  final Definition definition;
  final bool isBookmarked;
  final List<Definition> bookmarkedDefinitions;

  const WordDetailPage({
    Key? key,
    required this.definition,
    required this.isBookmarked,
    required this.bookmarkedDefinitions,
  }) : super(key: key);

  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
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

          //Positioned container for cards
          Positioned(
            top: 150,
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
                    //Card for Definition
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
                              DefinitionWidget(def: widget.definition.def),
                              if (widget.definition.def.isNotEmpty &&
                                  widget.definition.def[0]['cats'] != null) ...[
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

                    // Card for Related Terms
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
                                widget.definition.stems.join(', '),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card for Functional Label
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
                              Text(widget.definition.fl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Container under appbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 150,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.definition.id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      HwiWidget(hwi: widget.definition.hwi),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onSearchPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicalDictionary(),
            ),
          );
        },
        onBookmarkPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookmarkListPage(
                bookmarkedTerms: widget.bookmarkedDefinitions,
                onUnbookmark: (term) {
                  setState(() {
                    widget.bookmarkedDefinitions.remove(term);
                  });
                },
                allTerms: const [],
              ),
            ),
          );
        },
      ),
    );
  }
}

// HWI - Pronunciation Widget
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
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Capitalize Widget
String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

// Definition Widget
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
