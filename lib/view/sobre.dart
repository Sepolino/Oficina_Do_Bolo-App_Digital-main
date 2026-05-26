import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sobre")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Objetivo: Este aplicativo foi desenvolvido para simular o funcionamento de um cardápio digital/online voltado para uma loja especializada na venda de bolos. O projeto foi construído como parte de um estudo prático utilizando o framework Flutter, permitindo a criação de interfaces modernas e responsivas para dispositivos móveis, com a sua própria linguagem de programação Dart.\n"),
              Text("Aluno: Marcus Vínicius Milan da Silva"),
              Text("Disciplina: Programação para Dispositívos Móveis\nInstituição: FATEC\nProfessor: Rodrigo Plotz"),
            ],
          ),
        ),
      ),
    );
  }
}
