import 'package:flutter/material.dart';
import 'flashcard.dart';
import 'gerenciar_card.dart';

// Modelo do Flashcard com variáveis para cálculos
class Flashcard {
  String pergunta;
  String resposta;
  int repeticoes; // Quantas vezes foi revisado sucessivamente
  double fatorFacilidade; // Fator SM2 (padrão 2.5)
  int intervaloDias; // Dias até a próxima revisão

  Flashcard({
    required this.pergunta,
    required this.resposta,
    this.repeticoes = 0,
    this.fatorFacilidade = 2.5,
    this.intervaloDias = 0,
  });
}

// Modelo do Baralho que agora possui múltiplos cards
class Baralho {
  String nome;
  List<Flashcard> cards;

  Baralho({
    required this.nome,
    required this.cards,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Baralho> baralhos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // COMENTADO
      // appBar: AppBar(
      //   title: const Text('Wonkie Flashcards', style: TextStyle(fontWeight: FontWeight.bold)),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.bar_chart),
      //       tooltip: 'Estatísticas',
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => EstatisticasPage(baralhos: baralhos)),
      //         );
      //       },
      //     )
      //   ],
      // ),
      appBar: AppBar(
        title: const Text(
          'Wonkie',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Ver Estatísticas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstatisticasPage(baralhos: baralhos),
                ),
              );
            },
          ),
        ],
      ),
      body: baralhos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum baralho criado ainda.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: baralhos.length,
              itemBuilder: (context, index) {
                final baralho = baralhos[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(baralho.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text('${baralho.cards.length} flashcards adicionados'),
                      onTap: () {
                        if (baralho.cards.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Adicione perguntas ao baralho antes de estudar!')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FlashcardPage(baralho: baralho)),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_to_photos, color: Colors.blueGrey),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GerenciarCardsPage(baralho: baralho)),
                              );
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                baralhos.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novoBaralho = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CriarBaralhoPage()),
          );
          if (novoBaralho != null) {
            setState(() {
              baralhos.add(novoBaralho);
            });
          }
        },
      ),
    );
  }
}

// TELA DE CRIAÇÃO DO BARALHO (Apenas Nome)
class CriarBaralhoPage extends StatefulWidget {
  const CriarBaralhoPage({super.key});

  @override
  State<CriarBaralhoPage> createState() => _CriarBaralhoPageState();
}

class _CriarBaralhoPageState extends State<CriarBaralhoPage> {
  final TextEditingController nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Baralho')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Baralho',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (nomeController.text.isNotEmpty) {
                  final baralho = Baralho(nome: nomeController.text, cards: []);
                  Navigator.pop(context, baralho);
                }
              },
              child: const Text('Criar e Avançar'),
            ),
          ],
        ),
      ),
    );
  }
}

class EstatisticasPage extends StatelessWidget {
  final List<Baralho> baralhos;

  const EstatisticasPage({super.key, required this.baralhos});

  @override
  Widget build(BuildContext context) {
    int totalDeCards = 0;
    int totalRevisados = 0;
    double somaFacilidade = 0.0;

    for (var b in baralhos) {
      totalDeCards += b.cards.length;
      for (var card in b.cards) {
        if (card.repeticoes > 0) totalRevisados++;
        somaFacilidade += card.fatorFacilidade;
      }
    }

    double mediaFacilidade = totalDeCards > 0 ? (somaFacilidade / totalDeCards) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard e Estatísticas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visão Geral do Seu Aprendizado:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildStatCard('Total de Baralhos', '${baralhos.length}', Colors.blue),
            _buildStatCard('Total de Flashcards', '$totalDeCards', Colors.teal),
            _buildStatCard('Cards Já Revisados', '$totalRevisados', Colors.orange),
            _buildStatCard('Fator de Facilidade Médio', mediaFacilidade.toStringAsFixed(2), Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String titulo, String valor, Color cor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: cor, child: const Icon(Icons.analytics, color: Colors.white)),
        title: Text(titulo),
        trailing: Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}