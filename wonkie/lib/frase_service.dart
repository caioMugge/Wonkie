import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Frase {
  final String texto;
  final String autor;
  Frase({required this.texto, required this.autor});
}

class FraseService {
  // Frases de reserva, usadas se a API falhar (sem internet, limite, etc.)
  static final List<Frase> _reserva = [
    Frase(texto: 'Pequenos passos todos os dias levam longe.', autor: 'Wonkie'),
    Frase(texto: 'Revisar um pouco hoje vale mais que muito amanhã.', autor: 'Wonkie'),
    Frase(texto: 'Errar faz parte de aprender.', autor: 'Wonkie'),
  ];

  static Frase _fraseReserva() => _reserva[Random().nextInt(_reserva.length)];

  static Future<Frase> buscarFrase() async {
    try {
      final resposta = await http
          .get(Uri.https('zenquotes.io', '/api/random'))
          .timeout(const Duration(seconds: 4));

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body) as List;
        if (dados.isNotEmpty) {
          final texto = dados[0]['q'] as String;
          // Quando passa do limite, a API devolve um aviso no lugar da frase
          if (!texto.toLowerCase().contains('too many requests')) {
            return Frase(texto: texto, autor: dados[0]['a'] as String);
          }
        }
      }
    } catch (_) {
      // Sem internet ou timeout: cai na frase de reserva
    }
    return _fraseReserva();
  }
}