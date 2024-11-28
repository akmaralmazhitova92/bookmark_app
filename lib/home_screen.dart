import 'package:bookmark_app/bookmark_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmark_provider.dart';
import 'item.dart';

class HomeScreen extends StatelessWidget {
  final List<Item> items = List.generate(
    10,
    (index) => Item(
      id: index.toString(),
      title: 'Элемент $index',
      description: 'Описание элемента $index',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Закладки'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isBookmarked = bookmarkProvider.isBookmarked(item);

          return ListTile(
            title: Text(item.title),
            iconColor: Colors.red,
            subtitle: Text(item.description),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? Icons.add  : Icons.remove,
              ),
              onPressed: () {
                if (isBookmarked) {
                  bookmarkProvider.removeBookmark(item);
                } else {
                  bookmarkProvider.addBookmark(item);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
