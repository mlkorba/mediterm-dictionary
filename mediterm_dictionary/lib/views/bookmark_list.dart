import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart'; // Import your actual model file

class BookmarkListPage extends StatefulWidget {
  final List<Definition> bookmarkedTerms;

  BookmarkListPage({required this.bookmarkedTerms});

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
                _showUndoSnackBar(term);
              },
            ),
          );
        },
      ),
    );
  }
}
