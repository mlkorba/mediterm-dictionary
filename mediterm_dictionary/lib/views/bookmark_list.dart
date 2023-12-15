import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/reusable_widgets/reusable_widgets.dart';
import 'package:mediterm_dictionary/services/database_helper.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';
import 'package:mediterm_dictionary/views/medical_dictionary.dart';

class BookmarkListPage extends StatefulWidget {
  final List<Definition> allTerms;
  final ValueChanged<Definition> onUnbookmark;

  const BookmarkListPage({
    Key? key,
    required this.allTerms,
    required this.onUnbookmark,
  }) : super(key: key);

  @override
  _BookmarkListPageState createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  late List<Map<String, dynamic>> _bookmarks =
      []; // Variable to store bookmarks

  @override
  void initState() {
    super.initState();
    _loadBookmarks(); // Load bookmarks when the widget initializes
  }

  // Load bookmarks from the database
  Future<void> _loadBookmarks() async {
    _bookmarks = await DatabaseHelper.getAllBookmarks();
    setState(() {}); // Update the UI after loading bookmarks
  }

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
          onPressed: () async {
            // Re-add the term to the list if the user undoes the action
            await DatabaseHelper.insertBookmark({
              'id': term.id,
              'term': term.term,
              'definition': term.definition,
              'stems': term.stems.join(', '),
              'hwi': term.hwi.toString(),
              'prs': term.prs.toString(),
              'fl': term.fl,
              'def': term.def.toString(),
            });
            _loadBookmarks(); // Reload bookmarks after inserting
            widget.onUnbookmark(term); // Notify the parent widget
          },
        ),
      ),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
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
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          // You can navigate to the details page here if needed
                          // Example: Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WordDetailPage(
                          //       definition: term,
                          //       isBookmarked: true,
                          //       bookmarkedDefinitions: widget.bookmarkedTerms,
                          //     ),
                          //   ),
                          // );
                        },
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookmark['term'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.bookmark),
                            onPressed: () async {
                              // Remove the bookmark from the database
                              await DatabaseHelper.deleteBookmark(
                                  bookmark['id']);
                              _loadBookmarks(); // Reload bookmarks after deleting
                              _showUndoSnackBar(Definition.fromJson(bookmark));
                              widget.onUnbookmark(Definition.fromJson(
                                  bookmark)); // Notify the parent widget
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
      bottomNavigationBar: CustomBottomNavigationBar(
        onSearchPressed: () {
          // Navigate to the MedicalDictionary page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicalDictionary(),
            ),
          );
        },
        onBookmarkPressed: () {
          // Navigate to the BookmarkListPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookmarkListPage(
                allTerms: const [],
                onUnbookmark: (term) {},
              ),
            ),
          );
        },
      ),
    );
  }
}
