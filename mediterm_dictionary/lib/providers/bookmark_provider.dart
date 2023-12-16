import 'package:flutter/material.dart';
import 'package:mediterm_dictionary/models/model.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<Definition> _bookmarkedDefinitions = [];

  List<Definition> get bookmarkedDefinitions => _bookmarkedDefinitions;

  void toggleBookmark(Definition term) {
    if (_bookmarkedDefinitions.contains(term)) {
      _bookmarkedDefinitions.remove(term);
    } else {
      _bookmarkedDefinitions.add(term);
    }

    notifyListeners();
  }

  void removeBookmark(Definition term) {
    _bookmarkedDefinitions.remove(term);
    notifyListeners();
  }
}
