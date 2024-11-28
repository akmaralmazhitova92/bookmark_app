import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmark_provider.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final bookmarks = bookmarkProvider.bookmarkedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои закладки'), foregroundColor: Colors.green,
      ),
      body: bookmarks.isEmpty
          ? const Center(child: Text('Закладок пока нет!'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final item = bookmarks[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                );
              },
            ),
    );
  }
}
