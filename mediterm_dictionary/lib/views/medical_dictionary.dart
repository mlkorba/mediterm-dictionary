import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediterm_dictionary/services/api_service.dart';
import 'package:mediterm_dictionary/views/bookmark_list.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/word_details.dart';

class MedicalDictionary extends StatefulWidget {
  const MedicalDictionary({Key? key}) : super(key: key);

  @override
  _MedicalDictionaryState createState() => _MedicalDictionaryState();
}

class _MedicalDictionaryState extends State<MedicalDictionary> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService =
      ApiService('e685bd9f-83a4-429f-bfa1-599dfb152bec');
  List<Definition> definitions = [];
  List<Definition> bookmarkedDefinitions = [];
  late SharedPreferences _prefs;
  final String _lastSearchKey = 'lastSearch';

  @override
  void initState() {
    super.initState();
    _controller.clear();
  }

  void _search() async {
    final word = _controller.text.trim();
    if (word.isNotEmpty) {
      try {
        final results = await apiService.fetchDefinition(word);
        print('API Response: $results');
        setState(() {
          definitions = results
              .map<Definition>((dynamic entry) => Definition.fromJson(entry))
              .toList();
        });
        _saveLastSearch(word);
      } catch (e) {
        print('Error fetching definitions: $e');
      }
    }
  }

  Future<void> _saveLastSearch(String word) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_lastSearchKey, word);
  }

  void _unbookmarkTerm(Definition term) {
    setState(() {
      bookmarkedDefinitions.remove(term);
    });
  }

  void _clearTextField() {
    _controller.clear();
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
        automaticallyImplyLeading: false,
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
                        builder: (context) => const LoginScreen()));
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 78,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Container 2
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter a medical term',
                          border: InputBorder.none,
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: _search,
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clearTextField,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) => _search(),
                        onSubmitted: (value) => _search(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: definitions.length,
                      itemBuilder: (context, index) {
                        final term = definitions[index];
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
                                        bookmarkedDefinitions.contains(term),
                                    bookmarkedDefinitions:
                                        bookmarkedDefinitions,
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
                                  bookmarkedDefinitions.contains(term)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (bookmarkedDefinitions.contains(term)) {
                                      bookmarkedDefinitions.remove(term);
                                    } else {
                                      bookmarkedDefinitions.add(term);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkListPage(
                      bookmarkedTerms: bookmarkedDefinitions,
                      onUnbookmark: (term) {
                        setState(() {
                          bookmarkedDefinitions.remove(term);
                        });
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
}
