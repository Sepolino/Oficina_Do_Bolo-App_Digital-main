import 'package:flutter/material.dart';
import '../repositories/bolo_repositories.dart';
import 'home.dart';

class PagamentoPagina extends StatefulWidget {
  const PagamentoPagina({super.key});

  @override
  State<PagamentoPagina> createState() => _PagamentoPaginaState();
}

class _PagamentoPaginaState extends State<PagamentoPagina> {
  String metodoSelecionado = 'Cartão de Crédito';
  final TextEditingController _cartaoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    _cartaoController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  void _showMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validarCartao() {
    final nome = _nomeController.text.trim();
    final numero = _cartaoController.text.trim().replaceAll(' ', '');

    if (nome.isEmpty) {
      _showMensagem('Por favor, informe o nome do cartão.');
      return false;
    }

    if (numero.isEmpty) {
      _showMensagem('Por favor, informe o número do cartão.');
      return false;
    }

    if (numero.length < 13 || numero.length > 19) {
      _showMensagem('Informe um número de cartão válido.');
      return false;
    }

    return true;
  }

  void _finalizarPagamento() {
    if (metodoSelecionado == 'Cartão de Crédito' && !_validarCartao()) {
      return;
    }

    _showMensagem('Pagamento aprovado com sucesso!');

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
        (route) => false,
      );
    });
  }

  Widget _opcaoMetodo(String metodo, IconData icone) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RadioListTile<String>(
        value: metodo,
        groupValue: metodoSelecionado,
        title: Text(metodo),
        secondary: Icon(icone, color: Colors.pink.shade700),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              metodoSelecionado = value;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade400,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumo do pagamento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total: R\$ ${carrinhoRepo.valorTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Esta é uma simulação de pagamento. Escolha a forma desejada e finalize.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _opcaoMetodo('Cartão de Crédito', Icons.credit_card),
              _opcaoMetodo('Pix', Icons.qr_code),
              _opcaoMetodo('Boleto', Icons.receipt_long),

              if (metodoSelecionado == 'Cartão de Crédito') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _nomeController,
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: Colors.pink,
                  decoration: InputDecoration(
                    labelText: 'Nome completo no cartão',
                    labelStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cartaoController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: Colors.pink,
                  decoration: InputDecoration(
                    labelText: 'Número do cartão',
                    labelStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ] else if (metodoSelecionado == 'Pix') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PIX rápido e seguro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Copie a chave abaixo e use no seu app bancário:',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        'meupix@oficinadobolo.com',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Valor: R\$ 0,00',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Boleto bancário',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pague até 3 dias úteis na sua agência ou internet banking.',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Vencimento: 07/05/2026',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Linha digitável:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      SelectableText(
                        '34191.79001 01043.510047 91020.150008 5 97880000010000',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _finalizarPagamento,
                  child: const Text(
                    'Finalizar Pagamento',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
