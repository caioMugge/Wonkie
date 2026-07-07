import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class EstatisticasPage extends StatelessWidget {
  final List<Baralho> baralhos;

  const EstatisticasPage({super.key, required this.baralhos});

  @override
  Widget build(BuildContext context) {
    int totalDeBaralhos = baralhos.length;
    int totalDeCards = 0;
    int cardsRevisados = 0;
    int cardsNovos = 0;
    double somaFacilidade = 0.0;

    for (var baralho in baralhos) {
      totalDeCards += baralho.cards.length;
      for (var card in baralho.cards) {
        somaFacilidade += card.fatorFacilidade;
        if (card.repeticoes > 0) {
          cardsRevisados++;
        }else {
          cardsNovos++;
        }
      }
    }

    double mediaFacilidade = totalDeCards > 0 ? (somaFacilidade / totalDeCards) : 2.5;

    double pctRevisados = totalDeCards > 0 ? (cardsRevisados / totalDeCards) : 0.0;
    double pctNovos = totalDeCards > 0 ? (cardsNovos / totalDeCards) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas de Estudo', style: TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo Geral', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard('Baralhos', '$totalDeBaralhos', Colors.blueAccent),
                 _buildStatCard('Total Cards', '$totalDeCards', Colors.teal),
                _buildStatCard('Revisados', '$cardsRevisados', Colors.green),
                _buildStatCard('Fator EF Médio', mediaFacilidade.toStringAsFixed(2), Colors.purpleAccent),
              ],
            ),
             const SizedBox(height: 35),
            const Text(
              'Progresso de Memorização',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // --- ANIMAÇÃO EXCLUSIVA (Gráfico de barras animado via Tween) ---
            Card(
              // padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Proporção de Cartões', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),
                  
                  // Barra de Cards Revisados
                  _buildAnimatedBar('Revisados ($cardsRevisados)', pctRevisados, Colors.green),
                  const SizedBox(height: 15),
                  
                  // Barra de Cards Novos
                  _buildAnimatedBar('Novos / Não Estudados ($cardsNovos)', pctNovos, Colors.orangeAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildStatCard(String titulo, String valor, Color cor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cor),
            ),
          ],
        ),
      ),
    );
  }

  // Widget que renderiza a barra com animação implícita controlada por tempo
  Widget _buildAnimatedBar(String rotulo, double porcentagem, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: porcentagem),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutBack, // Curva de animação estilizada com leve efeito elástico
          builder: (context, value, child) {
            return Stack(
              children: [
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value > 0 ? value : 0.01, // Evita bug visual se for 0
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}