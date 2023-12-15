import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';
import 'package:mediterm_dictionary/views/word_details.dart';

class BookmarkListPage extends StatefulWidget {
  final List<Definition> bookmarkedTerms;
  final List<Definition> allTerms;
  final ValueChanged<Definition> onUnbookmark;

  const BookmarkListPage({
    Key? key,
    required this.bookmarkedTerms,
    required this.allTerms,
    required this.onUnbookmark,
  }) : super(key: key);

  @override
  _BookmarkListPageState createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  // SnackBar
  void _showUndoSnackBar(Definition term) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${term.term.replaceAll('*', '')} was unbookmarked',
          textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Re-add the term to the list if the user undoes the action
            setState(() {
              widget.bookmarkedTerms.add(term);
            });
            widget.onUnbookmark(term); // Notify the parent widget
          },
        ),
      ),
    );
  }

  // Capitalize First Letter
  // String _capitalizeFirstLetter(String input) {
  //   if (input.isEmpty) {
  //     return input;
  //   }
  //   return input[0].toUpperCase() + input.substring(1);
  // }

  // Page Build
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
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
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailPage(
                                definition: term,
                                isBookmarked:
                                    widget.bookmarkedTerms.contains(term),
                                bookmarkedDefinitions: widget.bookmarkedTerms,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                term.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              widget.bookmarkedTerms.contains(term)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            onPressed: () {
                              setState(() {
                                // Remove the term from the list of displayed terms
                                widget.bookmarkedTerms.remove(term);
                              });
                              _showUndoSnackBar(term);
                              widget.onUnbookmark(
                                  term); // Notify the parent widget
                            },
                          ),
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
