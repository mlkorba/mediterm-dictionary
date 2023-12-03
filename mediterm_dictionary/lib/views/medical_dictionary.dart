import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediterm_dictionary/models/model.dart';
import 'package:mediterm_dictionary/views/word_details.dart'; // Import the model file

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
  late SharedPreferences _prefs;
  final String _lastSearchKey = 'lastSearch';

  @override
  void initState() {
    super.initState();
    _loadLastSearch();
  }

  Future<void> _loadLastSearch() async {
    _prefs = await SharedPreferences.getInstance();
    final lastSearch = _prefs.getString(_lastSearchKey) ?? '';
    _controller.text = lastSearch;
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
        title: const Text('MediTerm Dictionary'),
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
              child: const Text('Search'),
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
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the detail page when a word is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WordDetailPage(
                                  definition: definitions[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                definitions[index].term,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(definitions[index].definition),
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
