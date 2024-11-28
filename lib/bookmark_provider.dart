import 'package:flutter/material.dart';
import 'item.dart';

class BookmarkProvider with ChangeNotifier {
  final List<Item> _bookmarkedItems = [];

  List<Item> get bookmarkedItems => _bookmarkedItems;

  void addBookmark(Item item) {
    if (!_bookmarkedItems.contains(item)) {
      _bookmarkedItems.add(item);
      notifyListeners();
    }
  }

  void removeBookmark(Item item) {
    _bookmarkedItems.remove(item);
    notifyListeners();
  }

  bool isBookmarked(Item item) {
    return _bookmarkedItems.contains(item);
  }
}
