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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3E50),
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 63, 98, 131),
          secondary: const Color(0xFF1ABC9C),
        ),  
        scaffoldBackgroundColor: const Color(0xFF121212),
    
      ),
      home: const HomePage(),
    );
  }
}