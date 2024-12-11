import 'package:bookmark_app/src/feature/search/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'EcoMarket App',
      
      home: SearchScreen(),
    );
  }
}
