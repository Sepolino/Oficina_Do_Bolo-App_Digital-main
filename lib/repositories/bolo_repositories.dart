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