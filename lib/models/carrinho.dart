import 'bolos.dart';

class carrinho {
  final bolos bolo;
  int quantidade;

  carrinho({
    required this.bolo,
    required this.quantidade,
  });
}

class CarrinhoRepository {
  final List<carrinho> itens = [];

  void adicionar(carrinho item) {
    itens.add(item);
  }

  void remover(carrinho item) {
    itens.remove(item);
  }

  double get valorTotal {
    double total = 0;
    for (var item in itens) {
      total += item.bolo.preco * item.quantidade;
    }
    return total;
  }
}

final carrinhoRepo = CarrinhoRepository();