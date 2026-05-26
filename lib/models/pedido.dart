import 'carrinho.dart';

class Pedido{
  final List<carrinho> itens;
  final double total;

  Pedido({
    required this.itens,
    required this.total,
  });
}