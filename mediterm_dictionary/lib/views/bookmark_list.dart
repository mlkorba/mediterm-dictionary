// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';

class BookmarkListPage extends StatefulWidget {
  final List<Definition> bookmarkedTerms;
  final ValueChanged<Definition> onUnbookmark;

  BookmarkListPage({
    required this.bookmarkedTerms,
    required this.onUnbookmark,
  });

  @override
  _BookmarkListPageState createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  void _showUndoSnackBar(Definition term) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            '${_capitalizeFirstLetter(term.term.replaceAll('*', ''))} was unbookmarked',
            textAlign: TextAlign.center,
          ),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Re-add the term to the list if the user undoes the action
            setState(() {
              widget.bookmarkedTerms.add(term);
            });
          },
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

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
          Column(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    'Bookmark List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.red],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                      20.0), // Adjust this value for the top-right corner radius
                  topLeft: Radius.circular(
                      20.0), // Adjust this value for the top-right corner radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: widget.bookmarkedTerms.length,
                  itemBuilder: (context, index) {
                    final term = widget.bookmarkedTerms[index];
                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          _capitalizeFirstLetter(term.term.replaceAll('*', '')),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.bookmark),
                          onPressed: () {
                            setState(() {
                              widget.bookmarkedTerms.remove(term);
                            });
                            _showUndoSnackBar(term);
                            widget.onUnbookmark(term);
                          },
                        ),
                      ),
                    );
                  }, // itemBuilder
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
