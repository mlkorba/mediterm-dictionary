import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';

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
            '${term.term} was unbookmarked',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Terms'),
      ),
      body: ListView.builder(
        itemCount: widget.bookmarkedTerms.length,
        itemBuilder: (context, index) {
          final term = widget.bookmarkedTerms[index];
          return ListTile(
            title: Text(term.term),
            subtitle: Text(term.definition),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                setState(() {
                  widget.bookmarkedTerms.remove(term);
                });

                // Show the undo snackbar and pass the updated list back to MedicalDictionary
                _showUndoSnackBar(term);
                widget.onUnbookmark(term);
              },
            ),
          );
        },
      ),
    );
  }
}
