import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/word_details.dart'; // Import the model file
import 'package:mediterm_dictionary/views/bookmark_list.dart'; // Import the bookmark list page

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
    await _prefs.setString(_lastSearchKey, word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'MediTerm Dictionary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter a medical term',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(200, 40),
                disabledForegroundColor: Colors.blue.withOpacity(0.38),
                disabledBackgroundColor: Colors.blue.withOpacity(0.12),
              ),
              child: const Text(
                'Search',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkListPage(
                      bookmarkedTerms: bookmarkedDefinitions,
                    ),
                  ),
                );
              },
              child: const Text('View Bookmarks'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: definitions.isEmpty
                  ? const Center(
                      child: Text('No results found.'),
                    )
                  : ListView.builder(
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
                                    fontWeight: FontWeight.bold),
                              ),
                                  // Other details you might want to display
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
          ],
        ),
      ),
    );
  }
}
