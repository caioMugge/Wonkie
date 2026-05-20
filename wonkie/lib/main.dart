import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const Wonkie());
}

class Wonkie extends StatelessWidget {
  const Wonkie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wonkie',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}