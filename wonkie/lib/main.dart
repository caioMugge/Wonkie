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
      theme: ThemeData( // <-- Certifique-se de que NÃO tem const aqui
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3E50),
          brightness: Brightness.dark,
          primary: const Color(0xFF1A252F),
          secondary: const Color(0xFF1ABC9C),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        // cardTheme: CardTheme( // <-- Sem const aqui também
        //   color: const Color(0xFF1E1E1E),
        //   elevation: 4,
        // ),
      ),
      home: const HomePage(),
    );
  }
}