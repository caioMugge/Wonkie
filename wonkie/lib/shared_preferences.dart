import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyUltimoEstudo = 'ultimo_estudo';
  static const String _keyTemaEscuro = 'tema_escuro';

  // Salva a data/hora do último estudo finalizado
  static Future<void> salvarUltimoEstudo(DateTime data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUltimoEstudo, data.toIso8601String());
  }

  // Recupera o último estudo
  static Future<String> getUltimoEstudo() async {
    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString(_keyUltimoEstudo);
    if (dataStr != null) {
      final data = DateTime.parse(dataStr);
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    }
    return 'Nenhum estudo realizado ainda';
  }

  // Alternar preferência de Tema
  static Future<void> salvarTema(bool ehEscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTemaEscuro, ehEscuro);
  }

  static Future<bool> getTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTemaEscuro) ?? true;
  }
}