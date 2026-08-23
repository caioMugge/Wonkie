import 'package:flutter/material.dart';
import 'shared_preferences.dart';
import 'splashScreen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const Wonkie());
}

final ValueNotifier<bool> temaEscuroNotifier = ValueNotifier<bool>(true);

class Wonkie extends StatefulWidget {
  const Wonkie({super.key});

  @override
  State<Wonkie> createState() => _WonkieState();
}

class _WonkieState extends State<Wonkie> {
  @override
  void initState() {
    super.initState();
    _carregarTemaSalvo();
  }

  Future<void> _carregarTemaSalvo() async {
    final ehEscuro = await PreferencesService.getTema();
    temaEscuroNotifier.value = ehEscuro;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: temaEscuroNotifier,
      builder: (context, ehEscuro, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wonkie',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C3E50),
              brightness: ehEscuro ? Brightness.dark : Brightness.light,
              primary: const Color.fromARGB(255, 68, 104, 137),
              secondary: const Color(0xFF1ABC9C),
            ),
            scaffoldBackgroundColor:
                ehEscuro ? const Color(0xFF121212) : Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1ABC9C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}