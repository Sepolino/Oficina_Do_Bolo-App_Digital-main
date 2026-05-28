import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoricoPedidosView extends StatelessWidget {
  const HistoricoPedidosView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Pedidos'),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(
              child: Text('Faça login para ver seu histórico de pedidos'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pedidos')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar pedidos: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pedidos = snapshot.data!.docs;

                if (pedidos.isEmpty) {
                  return const Center(
                    child: Text('Nenhum pedido encontrado.'),
                  );
                }

                final pedidosOrdenados = List.from(pedidos)
                  ..sort((a, b) {
                    final aData = a.data() as Map<String, dynamic>;
                    final bData = b.data() as Map<String, dynamic>;
                    final aCreated = aData['createdAt'] is Timestamp
                        ? (aData['createdAt'] as Timestamp).toDate()
                        : DateTime.tryParse(aData['createdAt']?.toString() ?? '');
                    final bCreated = bData['createdAt'] is Timestamp
                        ? (bData['createdAt'] as Timestamp).toDate()
                        : DateTime.tryParse(bData['createdAt']?.toString() ?? '');
                    if (aCreated == null && bCreated == null) return 0;
                    if (aCreated == null) return 1;
                    if (bCreated == null) return -1;
                    return bCreated.compareTo(aCreated);
                  });

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemCount: pedidosOrdenados.length,
                  itemBuilder: (context, index) {
                    final doc = pedidosOrdenados[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final total = data['total'];
                    final totalValor = (total is num)
                        ? total.toDouble()
                        : double.tryParse(total?.toString() ?? '0') ?? 0.0;
                    final createdAt = data['createdAt'] is Timestamp
                        ? (data['createdAt'] as Timestamp).toDate()
                        : DateTime.tryParse(data['createdAt']?.toString() ?? '');
                    final rawItems = data['items'];
                    final items = <Map<String, dynamic>>[];

                    if (rawItems is List) {
                      for (final item in rawItems) {
                        if (item is Map) {
                          items.add(Map<String, dynamic>.from(item));
                        }
                      }
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pedido ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'R\$ ${totalValor.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Itens: ${items.length}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            if (createdAt != null)
                              Text(
                                'Data: ${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            const SizedBox(height: 12),
                            const Text(
                              'Detalhes:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...items.map((item) {
                              final itemData = Map<String, dynamic>.from(item as Map);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '${itemData['nome'] ?? 'Produto'} x${itemData['quantidade'] ?? 1} - R\$ ${(itemData['preco'] is num ? (itemData['preco'] as num).toDouble() : double.tryParse(itemData['preco']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
