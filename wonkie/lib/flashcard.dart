import 'package:flutter/material.dart';
import 'homepage.dart';

class FlashcardPage extends StatefulWidget {

  final Baralho baralho;

  const FlashcardPage({
    super.key,
    required this.baralho,
  });

  @override
  State<FlashcardPage> createState() =>
      _FlashcardPageState();
}

class _FlashcardPageState
    extends State<FlashcardPage> {

  bool mostrarResposta = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baralho.nome),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  onde fica a pergunta
                    Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Text(
                          widget.baralho.pergunta,
                          textAlign:
                              TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // onde fica a resposta
                    const Divider(),
                    if (mostrarResposta)
                      Padding(
                        padding:
                            const EdgeInsets.all(
                                20),
                        child: Transform.scale(
                          scale: 1.2,
                          child: Text(
                            widget.baralho.resposta,
                            textAlign:
                                TextAlign.center,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(
                                255,
                                63,
                                63,
                                63),
                        foregroundColor:
                            Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarResposta =
                              !mostrarResposta;
                        });
                      },
                      child: Text(
                        mostrarResposta
                            ? 'Esconder Resposta'
                            : 'Mostrar Resposta',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // botoes de nivel
            Padding(
              padding:
                  const EdgeInsets.only(
                      bottom: 40),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 52, 52), 
                    foregroundColor: Colors.white,     
                  ),
                    onPressed: () {},
                    child: const Text('De Novo'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 52, 52), 
                    foregroundColor: Colors.white,     
                  ),
                    onPressed: () {},
                    child: const Text('Difícil'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 52, 52), 
                    foregroundColor: Colors.white,     
                  ),
                    onPressed: () {},
                    child: const Text('Médio'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 52, 52), 
                    foregroundColor: Colors.white,     
                  ),
                    onPressed: () {},
                    child: const Text('Fácil'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}