import 'package:flutter/material.dart';

void main() {
  runApp(const Wonkie());
}

class Wonkie extends StatelessWidget {
  const Wonkie({super.key});

  @override
  Widget build(BuildContext context) {
    final perguntas = ['Você gosta de dispositivos móveis?'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Wonkie',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            ),
        ),
        body: Center(
          child: Column(
            children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                        child: Transform.scale(
                          scale: 1.5,
                          child: Text(perguntas[0]),
                        ),
                      ),   
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Text("Sim"),
                      ),
                    ),   
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    )),
                    onPressed: () {},
                    child: const Text('De Novo'),
                  ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    )),
                    onPressed: () {},
                    child: const Text('Difícil'),
                  ),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    )),
                    onPressed: () {},
                    child: const Text('Médio'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    )),
                  onPressed: () {}, 
                  child: const Text('Fácil'), 
                ),
                ]
                ),
            ),
              ],
            )
          ),
      ),
      );
  }
}
