import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bolos.dart';
import '../models/carrinho.dart';
import '../repositories/api_service.dart';
import '../repositories/firestore_service.dart';
import 'login_principal.dart';
import 'carrinho_pagina.dart';
import 'detalhe_bolo.dart';
import 'historico_pedidos.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  String filtroTamanho = '';
  String pesquisa = '';
  late Future<String> _tipFuture;
  late Future<String?> _promoFuture;
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tipFuture = _apiService.fetchBakingTip();
    _promoFuture = _firestoreService.fetchPromotion();
  }

  void _refreshTip() {
    setState(() {
      _tipFuture = _apiService.fetchBakingTip();
    });
  }

  void _refreshPromo() {
    setState(() {
      _promoFuture = _firestoreService.fetchPromotion();
    });
  }

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
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoricoPedidosView()),
              );
            },
          ),
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

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar bolos: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final valor = data['valor'];

            double preco = 0.0;
            if (valor is num) {
              preco = valor.toDouble();
            } else if (valor is String) {
              preco = double.tryParse(valor.replaceAll(',', '.')) ?? 0.0;
            }

            return bolos(
              nome: data['nome']?.toString() ?? 'Sem nome',
              ingredientes: data['ingredientes']?.toString() ?? 'Sem ingredientes',
              preco: preco,
              tamanho: data['tamanho']?.toString() ?? '',
              foto: data['imagem']?.toString() ?? '',
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Olá, ${FirebaseAuth.instance.currentUser?.email ?? 'Cliente'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder<String?>(
                  future: _promoFuture,
                  builder: (context, promoSnapshot) {
                    if (promoSnapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    final promo = promoSnapshot.data;
                    if (promo == null || promo.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Promoção especial',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  promo,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _refreshPromo,
                            tooltip: 'Atualizar promoção',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder<String>(
                  future: _tipFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 12),
                            Expanded(child: Text('Carregando dica do dia...')),
                          ],
                        ),
                      );
                    }

                    final tip = snapshot.data ?? 'Tente novamente para carregar a dica do dia.';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dica da Confeitaria',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tip,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _refreshTip,
                            tooltip: 'Atualizar dica',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

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
                                  errorBuilder: (_, _, _) =>
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bolo adicionado ao carrinho'),
                                        duration: Duration(milliseconds: 900),
                                      ),
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