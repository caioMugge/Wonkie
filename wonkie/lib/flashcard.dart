import 'package:flutter/material.dart';
import 'homepage.dart';
import 'dart:math';

class FlashcardPage extends StatefulWidget {
  final Baralho baralho;
  const FlashcardPage({super.key, required this.baralho});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int indiceAtual = 0;
  bool mostrarResposta = false;
  String infoCalculo = '';

  void _processarResposta(int qualidade) {
    final card = widget.baralho.cards[indiceAtual];

    if (qualidade >= 2) {
      if (card.repeticoes == 0) {
        card.intervaloDias = 1;
      } else if (card.repeticoes == 1) {
        card.intervaloDias = 6;
      } else {
        card.intervaloDias = (card.intervaloDias * card.fatorFacilidade).round();
      }
      card.repeticoes++;
    } else {
      card.repeticoes = 0;
      card.intervaloDias = 0; 
    }

    card.fatorFacilidade = card.fatorFacilidade + (0.1 - (5 - qualidade) * (0.08 + (5 - qualidade) * 0.02));
    if (card.fatorFacilidade < 1.3) card.fatorFacilidade = 1.3;

    setState(() {
      infoCalculo = card.intervaloDias == 0 
          ? 'Próxima revisão: Em alguns minutos' 
          : 'Próxima revisão daqui a: ${card.intervaloDias} dias (Fator EF: ${card.fatorFacilidade.toStringAsFixed(2)})';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(infoCalculo), duration: const Duration(seconds: 2)),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          if (indiceAtual < widget.baralho.cards.length - 1) {
            indiceAtual++;
            mostrarResposta = false;
            infoCalculo = '';
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Baralho finalizado!')),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.baralho.cards[indiceAtual];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.baralho.nome} (${indiceAtual + 1}/${widget.baralho.cards.length})')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: mostrarResposta ? pi : 0),
                  builder: (context, double valorAngulo, child) {
                    final bool estaNoVerso = valorAngulo >= pi / 2;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) 
                        ..rotateY(valorAngulo),
                      alignment: Alignment.center,
                      child: Card(
                        color: estaNoVerso ? const Color(0xFF2C3E50) : const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.all(20),
                        child: Container(
                          width: 320,
                          height: 220,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: estaNoVerso ? Matrix4.rotationY(pi) : Matrix4.identity(),
                            child: estaNoVerso
                                ? Text(card.resposta, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                                : Text(card.pergunta, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mostrarResposta = !mostrarResposta;
                });
              },
              child: Text(mostrarResposta ? 'Ver Pergunta' : 'Mostrar Resposta'),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton('De Novo', Colors.red, () => _processarResposta(1)),
                  _buildActionButton('Difícil', Colors.orange, () => _processarResposta(2)),
                  _buildActionButton('Médio', Colors.blue, () => _processarResposta(3)),
                  _buildActionButton('Fácil', Colors.green, () => _processarResposta(4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String texto, Color cor, VoidCallback acao) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.white,
      ),
      onPressed: mostrarResposta ? acao : null, 
      child: Text(texto),
    );
  }
}