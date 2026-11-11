import 'package:flutter/material.dart';
import 'banco.dart';
import 'shared_preferences.dart';
import 'flashcard.dart';
import 'gerenciar_card.dart';
import 'estatisticas.dart';
import 'main.dart';
import 'frase_service.dart'; 

// MUDOU
class Flashcard {
  int? id;
  int? baralhoId;
  String pergunta;
  String resposta;
  int repeticoes;
  double fatorFacilidade;
  int intervaloDias;

  Flashcard({
    this.id,
    this.baralhoId,
    required this.pergunta,
    required this.resposta,
    this.repeticoes = 0,
    this.fatorFacilidade = 2.5,
    this.intervaloDias = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baralho_id': baralhoId,
      'pergunta': pergunta,
      'resposta': resposta,
      'repeticoes': repeticoes,
      'fatorFacilidade': fatorFacilidade,
      'intervaloDias': intervaloDias,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      baralhoId: map['baralho_id'],
      pergunta: map['pergunta'],
      resposta: map['resposta'],
      repeticoes: map['repeticoes'],
      fatorFacilidade: map['fatorFacilidade'],
      intervaloDias: map['intervaloDias'],
    );
  }
}

class Baralho {
  int? id;
  String nome;
  List<Flashcard> cards;

  Baralho({this.id, required this.nome, required this.cards});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//  MUDOU
class _HomePageState extends State<HomePage> {
  List<Baralho> baralhos = [];
  String ultimoEstudoStr = 'Carregando...';
  bool carregando = true;

  Frase? frase;
  bool carregandoFrase = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _carregarFrase(); // NOVO: chamada uma única vez ao abrir a tela
  }

  Future<void> _carregarDados() async {
    final list = await DatabaseHelper.instance.getBaralhosComCards();
    final prefData = await PreferencesService.getUltimoEstudo();
    setState(() {
      baralhos = list;
      ultimoEstudoStr = prefData;
      carregando = false;
    });
  }

   Future<void> _carregarFrase() async {
    setState(() => carregandoFrase = true);
    final f = await FraseService.buscarFrase();
    if (!mounted) return;
    setState(() {
      frase = f;
      carregandoFrase = false;
    });
  }

  Future<void> _alternarTema() async {
    final novoValor = !temaEscuroNotifier.value;
    temaEscuroNotifier.value = novoValor;
    await PreferencesService.salvarTema(novoValor);
  }

  Future<void> _editarBaralho(Baralho baralho) async {
    final nomeEditController = TextEditingController(text: baralho.nome);

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Baralho'),
        content: TextField(
          controller: nomeEditController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nome do Baralho'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (confirmou == true && nomeEditController.text.isNotEmpty) {
      await DatabaseHelper.instance
          .updateBaralho(baralho.id!, nomeEditController.text);
      _carregarDados();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Baralho atualizado!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wonkie Flashcards',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              temaEscuroNotifier.value ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Alternar tema',
            onPressed: () {
              setState(_alternarTema);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Ver Estatísticas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstatisticasPage(baralhos: baralhos),
                ),
              );
            },
          )
        ],
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                Card(
                  margin: const EdgeInsets.fromLTRB(15, 12, 15, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote,
                            color: Color(0xFF1ABC9C), size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: carregandoFrase
                              ? const Text('Carregando frase...')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      frase!.texto,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '— ${frase!.autor}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Inspirational quotes provided by ZenQuotes API',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Nova frase',
                          onPressed: carregandoFrase ? null : _carregarFrase,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black.withOpacity(0.25),
                  child: Row(
                    children: [
                      const Icon(Icons.history, color: Color(0xFF1ABC9C)),
                      const SizedBox(width: 8),
                      Text('Última sessão de estudo: $ultimoEstudoStr',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                Expanded(
                  child: baralhos.isEmpty
                      ? const Center(
                          child: Text('Nenhum baralho criado.'),
                        )
                      : ListView.builder(
                          itemCount: baralhos.length,
                          itemBuilder: (context, index) {
                            final baralho = baralhos[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: ListTile(
                                title: Text(
                                  baralho.nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('${baralho.cards.length} cards cadastrados'),
                                onTap: () async {
                                  if (baralho.cards.isEmpty) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FlashcardPage(baralho: baralho),
                                    ),
                                  );
                                  _carregarDados();
                                },
                                // MUDOU
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.orange),
                                      tooltip: 'Editar nome',
                                      onPressed: () => _editarBaralho(baralho),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_to_photos,
                                          color: Colors.blue),
                                      tooltip: 'Gerenciar cards',
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GerenciarCardsPage(
                                                    baralho: baralho),
                                          ),
                                        );
                                        _carregarDados();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      tooltip: 'Excluir baralho',
                                      onPressed: () async {
                                        await DatabaseHelper.instance
                                            .deleteBaralho(baralho.id!);
                                        _carregarDados();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novoBaralho = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CriarBaralhoPage()),
          );
          if (novoBaralho != null) {
            await DatabaseHelper.instance.insertBaralho(novoBaralho.nome);
            _carregarDados();
          }
        },
      ),
    );
  }
}

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
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (nomeController.text.isNotEmpty) {
                  Navigator.pop(
                      context, Baralho(nome: nomeController.text, cards: []));
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}