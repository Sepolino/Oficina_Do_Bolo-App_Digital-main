import '../models/bolos.dart';

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
    final index = itens.indexWhere(
      (element) => element.bolo.nome == item.bolo.nome,
    );

    if (index >= 0) {
      itens[index].quantidade += item.quantidade;
    } else {
      itens.add(item);
    }
  }

  void remover(carrinho item) {
    itens.remove(item);
  }

  void limpar() {
    itens.clear();
  }

  int get totalItens {
    return itens.fold(0, (total, item) => total + item.quantidade);
  }

  double get valorTotal {
    return itens.fold(
      0.0,
      (total, item) => total + (item.bolo.preco * item.quantidade),
    );
  }
}

final CarrinhoRepository carrinhoRepo = CarrinhoRepository();
