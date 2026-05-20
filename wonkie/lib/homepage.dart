import 'package:flutter/material.dart';
import 'flashcard.dart';

class Baralho {
  String nome;
  String pergunta;
  String resposta;

  Baralho({
    required this.nome,
    required this.pergunta,
    required this.resposta,
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

      appBar: AppBar(
        title: const Text(
          'Wonkie',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: baralhos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum baralho criado',
                style: TextStyle(fontSize: 18),
              ),
            )

          : ListView.builder(
              itemCount: baralhos.length,

              itemBuilder: (context, index) {

                final baralho = baralhos[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(

                    title: Text(
                      baralho.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(baralho.pergunta),

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FlashcardPage(
                                baralho: baralho,
                              ),
                        ),
                      );
                    },

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),

                      onPressed: () {

                        setState(() {
                          baralhos.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor:
            const Color.fromARGB(255, 63, 63, 63),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () async {

          final novoBaralho = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const CriarBaralhoPage(),
            ),
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

class CriarBaralhoPage extends StatefulWidget {
  const CriarBaralhoPage({super.key});

  @override
  State<CriarBaralhoPage> createState() =>
      _CriarBaralhoPageState();
}

class _CriarBaralhoPageState
    extends State<CriarBaralhoPage> {

  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController perguntaController =
      TextEditingController();

  final TextEditingController respostaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Criar Baralho'),
      ),

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

            TextField(
              controller: perguntaController,

              decoration: const InputDecoration(
                labelText: 'Pergunta',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: respostaController,

              decoration: const InputDecoration(
                labelText: 'Resposta',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(
                        255, 63, 63, 63),

                foregroundColor: Colors.white,
              ),

              onPressed: () {

                final baralho = Baralho(
                  nome: nomeController.text,
                  pergunta: perguntaController.text,
                  resposta: respostaController.text,
                );

                Navigator.pop(context, baralho);
              },

              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}