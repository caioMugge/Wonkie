import 'package:flutter/material.dart';
import 'banco.dart';
import 'homepage.dart';

class GerenciarCardsPage extends StatefulWidget {
  final Baralho baralho;
  const GerenciarCardsPage({super.key, required this.baralho});

  @override
  State<GerenciarCardsPage> createState() => _GerenciarCardsPageState();
}

class _GerenciarCardsPageState extends State<GerenciarCardsPage> {
  final TextEditingController perguntaController = TextEditingController();
  final TextEditingController respostaController = TextEditingController();

  Future<void> _salvarCard() async {
    if (perguntaController.text.isNotEmpty &&
        respostaController.text.isNotEmpty) {
      if (widget.baralho.id == null) return;

      final novoFlashcard = await DatabaseHelper.instance.insertFlashcard(
        widget.baralho.id!,
        perguntaController.text,
        respostaController.text,
      );

      setState(() {
        widget.baralho.cards.add(novoFlashcard);
      });

      perguntaController.clear();
      respostaController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flashcard salvo no banco de dados!')),
        );
      }
    }
  }

  Future<void> _editarCard(int index) async {
    final card = widget.baralho.cards[index];
    final perguntaEditController = TextEditingController(text: card.pergunta);
    final respostaEditController = TextEditingController(text: card.resposta);

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: perguntaEditController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Pergunta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: respostaEditController,
              decoration: const InputDecoration(labelText: 'Resposta'),
            ),
          ],
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

    if (confirmou == true &&
        perguntaEditController.text.isNotEmpty &&
        respostaEditController.text.isNotEmpty) {
      card.pergunta = perguntaEditController.text;
      card.resposta = respostaEditController.text;

      await DatabaseHelper.instance.updateFlashcard(card);

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flashcard atualizado!')),
        );
      }
    }
  }

  Future<void> _deletarCard(int index) async {
    final card = widget.baralho.cards[index];
    if (card.id != null) {
      await DatabaseHelper.instance.deleteFlashcard(card.id!);
      setState(() {
        widget.baralho.cards.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards: ${widget.baralho.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: perguntaController,
              decoration: const InputDecoration(
                labelText: 'Pergunta do Flashcard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: respostaController,
              decoration: const InputDecoration(
                labelText: 'Resposta do Flashcard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Questão'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _salvarCard,
            ),
            const Divider(height: 40),
            const Text(
              'Questões Atuais:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: widget.baralho.cards.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum card cadastrado neste baralho.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.baralho.cards.length,
                      itemBuilder: (context, index) {
                        final card = widget.baralho.cards[index];
                        return ListTile(
                          title: Text(card.pergunta),
                          subtitle: Text('Resp: ${card.resposta}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Editar card',
                                onPressed: () => _editarCard(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                tooltip: 'Excluir card',
                                onPressed: () => _deletarCard(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}