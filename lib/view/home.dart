import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bolos.dart';
import '../models/carrinho.dart';
import 'login_principal.dart';
import 'carrinho_pagina.dart';
import 'detalhe_bolo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  String filtroTamanho = '';
  String pesquisa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPrincipal()),
            );
          },
        ),
        title: Image.asset('lib/imgs/oficinaLOGO.png', height: 105),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarrinhoView()),
              );
            },
          )
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bolos').snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return bolos(
              nome: data['nome'],
              ingredientes: data['ingredientes'],
              preco: (data['valor'] is num) ? (data['valor'] as num).toDouble() : 0.0,
              tamanho: data['tamanho'],
              foto: data['imagem'],
            );
          }).toList();

          final listaFiltrada = lista.where((b) {
            final filtroOk = filtroTamanho.isEmpty || b.tamanho == filtroTamanho;
            final pesquisaOk = pesquisa.isEmpty ||
                b.nome.toLowerCase().contains(pesquisa.toLowerCase());
            return filtroOk && pesquisaOk;
          }).toList();

          return Column(
            children: [

              // --- PESQUISA ---
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Pesquisar bolo...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => pesquisa = value);
                  },
                ),
              ),

              // --- FILTROS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Expanded(child: _botaoFiltro("Pequeno")),
                    const SizedBox(width: 4),
                    Expanded(child: _botaoFiltro("Médio")),
                    const SizedBox(width: 4),
                    Expanded(child: _botaoFiltro("Grande")),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filtroTamanho = '';
                        });
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // --- LISTA ---
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listaFiltrada.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final bolo = listaFiltrada[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalheBoloView(bolo: bolo),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // --- IMAGEM ---
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Image.network(
                                  bolo.foto,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image),
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            // --- TEXTO ---
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                bolo.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                "R\$ ${bolo.preco.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),

                            const Spacer(),

                            // --- BOTÃO ---
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    carrinhoRepo.adicionar(
                                      carrinho(bolo: bolo, quantidade: 1),
                                    );
                                  },
                                  child: const Text("Adicionar"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _botaoFiltro(String tamanho) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          filtroTamanho = tamanho;
        });
      },
      child: Text(tamanho),
    );
  }
}