import 'package:flutter/material.dart';
import '../models/bolos.dart';

class DetalheBoloView extends StatelessWidget {
  final bolos bolo;

  const DetalheBoloView({super.key, required this.bolo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 255, 241, 245),
      appBar: AppBar(
        title: Text(bolo.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: bolo.foto.isEmpty
                    ? const Center(child: Icon(Icons.image, size: 120))
                    : (Uri.tryParse(bolo.foto)?.hasAbsolutePath ?? false)
                        ? Image.network(
                            bolo.foto,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image, size: 120),
                          )
                        : Image.asset(
                            bolo.foto,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image, size: 120),
                          ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              bolo.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Tamanho: ${bolo.tamanho}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "R\$ ${bolo.preco.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ingredientes:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              bolo.ingredientes,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}