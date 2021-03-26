// Fundamentals of BLOC pattern
import 'package:flutter/material.dart';
import 'package:news_bloc/news_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: NewsPage(),
    );
  }
}
