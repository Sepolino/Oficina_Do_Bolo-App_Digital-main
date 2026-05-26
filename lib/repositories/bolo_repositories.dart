import '../models/carrinho.dart';
import '../models/pedido.dart';
import '../models/bolos.dart';
import '../models/user.dart';

class boloRepository{
  static List<bolos> tabela = [
    bolos(
      nome: 'Chocolate Belga Tradicional', 
      foto: 'lib/imgs/chocolate_bolo.png',
      preco: 49.00,
      ingredientes: 'Farinha de trigo, açúcar, ovos, leite, chocolate em pó, óleo, fermento e sal. Cobertura: leite condensado, chocolate e creme de leite.',
      tamanho: 'Grande'),
  
    bolos(
      nome: 'Nuvem de Baunilha', 
      foto: 'lib/imgs/baunilha_bolo.png',
      preco: 39.00,
      ingredientes: 'Farinha de trigo, açúcar, ovos, leite, chocolate em pó, óleo, fermento e sal. Cobertura: leite condensado, chocolate e creme de leite.',
      tamanho: 'Médio'),
    
    bolos(
      nome: 'Pérola de Morango', 
      foto: 'lib/imgs/morango_bolo.png',
      preco: 54.90,
      ingredientes: 'Farinha de trigo, açúcar, ovos, leite, chocolate em pó, óleo, fermento e sal. Cobertura: leite condensado, chocolate e creme de leite.',
      tamanho: 'Médio'),
  ];

}

class userRepository{
  static List<user> tabelauser = [];
}

class carrinhoRepository {

  // LISTA PRIVADA
  final List<carrinho> _itens = [];

  // GET PARA ACESSAR OS ITENS
  List<carrinho> get itens => _itens;

  // ================= ADICIONAR =================
  void adicionar(carrinho item) {

    // VERIFICA SE O BOLO JÁ EXISTE NO CARRINHO
    int index = _itens.indexWhere(
      (element) => element.bolo.nome == item.bolo.nome,
    );

    if (index >= 0) {
      // SE JÁ EXISTE → SOMA QUANTIDADE
      _itens[index].quantidade += item.quantidade;
    } else {
      // SE NÃO EXISTE → ADICIONA NOVO
      _itens.add(item);
    }
  }

  // ================= REMOVER =================
  void remover(carrinho item) {
    _itens.remove(item);
  }

  // ================= LIMPAR =================
  void limpar() {
    _itens.clear();
  }

  // ================= TOTAL DE ITENS =================
  int get totalItens {
    return _itens.fold(0, (total, item) => total + item.quantidade);
  }

  // ================= VALOR TOTAL =================
  double get valorTotal {
    return _itens.fold(
      0.0,
      (total, item) => total + (item.bolo.preco * item.quantidade),
    );
  }
}

final carrinhoRepository carrinhoRepo = carrinhoRepository();

class pedidoRepository {
  final List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => _pedidos;

  // Criar pedido a partir do carrinho
  void adicionarPedido(List<carrinho> itensCarrinho, double total) {
    final pedido = Pedido(
      itens: List.from(itensCarrinho),
      total: total,
    );

    _pedidos.add(pedido);
  }

  // Limpar pedidos (opcional)
  void limpar() {
    _pedidos.clear();
  }
}