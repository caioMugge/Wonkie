import 'package:flutter/material.dart';

void main() {
  runApp(Wonkie());
}

class Wonkie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(), // Removido o Scaffold duplicado daqui
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mudamos o nome para 'scaffoldContext' para deixar claro que este contexto
    // está abaixo do Scaffold criado pelo Builder
    void _showIt(BuildContext scaffoldContext) {
      showModalBottomSheet(
        context: scaffoldContext,
        builder: (BuildContext modalContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Qual sua cor favorita?", style: TextStyle(fontSize: 18)),
              ),
              TextButton(
                child: Text("Azul"),
                onPressed: () {
                  Navigator.of(modalContext).pop(); // Usa o contexto do modal para fechar
                  print("Azul");
                },
              ),
              TextButton(
                child: Text("Verde"),
                onPressed: () {
                  Navigator.of(modalContext).pop();
                  print("Verde");
                },
              ),
              TextButton(
                child: Text("Vermelho"),
                onPressed: () {
                  Navigator.of(modalContext).pop();
                  print("Vermelho");
                },
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Center(
        // O Builder cria um novo contexto abaixo do Scaffold
        child: Builder(
          builder: (BuildContext innerContext) {
            return ElevatedButton(
              child: Text("Show"),
              onPressed: () => _showIt(innerContext), // Passa o contexto correto
            );
          },
        ),
      ),
    );
  }
}
