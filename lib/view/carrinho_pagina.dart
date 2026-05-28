import 'package:flutter/material.dart';
import '../models/carrinho.dart'; 
import 'pagamento_pagina.dart';

class CarrinhoView extends StatefulWidget {
  const CarrinhoView({super.key});

  @override
  State<CarrinhoView> createState() => _CarrinhoViewState();
}

class _CarrinhoViewState extends State<CarrinhoView> {
  final repo = carrinhoRepo;

  @override
  Widget build(BuildContext context) {
    final itens = repo.itens;

    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho (${repo.totalItens} itens)"),
        centerTitle: true,
      ),
      body: itens.isEmpty
          ? const Center(
              child: Text("Seu carrinho está vazio"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      final item = itens[index];

                      return ListTile(
                        leading: Image.network( // ✅ TROCA AQUI
                          item.bolo.foto,
                          width: 50,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.image),
                        ),
                        title: Text(item.bolo.nome),
                        subtitle: Text(
                          "Qtd: ${item.quantidade} | R\$ ${(item.bolo.preco * item.quantidade).toStringAsFixed(2)}"
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              repo.remover(item);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "R\$ ${repo.valorTotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PagamentoPagina(),
                              ),
                            );
                          },
                          child: const Text("Finalizar Pedido"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}