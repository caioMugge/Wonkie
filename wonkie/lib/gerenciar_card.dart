import 'package:flutter/material.dart';
import 'package:segundaavaliacao/flashcard.dart';
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

  void _salvarCard() {
    if (perguntaController.text.isNotEmpty && respostaController.text.isNotEmpty) {
      setState(() {
        widget.baralho.cards.add(
          Flashcard(
            pergunta: perguntaController.text,
            resposta: respostaController.text,
          ),
        );
      });
      perguntaController.clear();
      respostaController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flascard adicionado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards de: ${widget.baralho.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: perguntaController,
              decoration: const InputDecoration(labelText: 'Pergunta do Flashcard', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: respostaController,
              decoration: const InputDecoration(labelText: 'Resposta do Flashcard', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Questão'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: _salvarCard,
            ),
            const Divider(height: 40),
            const Text('Questões Atuais:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.baralho.cards.length,
                itemBuilder: (context, index) {
                  final card = widget.baralho.cards[index];
                  return ListTile(
                    title: Text(card.pergunta),
                    subtitle: Text('Resp: ${card.resposta}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red,),
                      onPressed: () {
                        setState(() {
                          widget.baralho.cards.removeAt(index);
                        });
                      }
                    ),
                  );
                },
              )),
          ],
        ),
      ),
    );
  }
}