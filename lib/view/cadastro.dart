import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _telController = TextEditingController();

  // 🔐 CADASTRO COM FIREBASE
  void _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    String senha = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      String mensagem;

      switch (e.code) {
        case 'email-already-in-use':
          mensagem = "Este email já está cadastrado";
          break;
        case 'invalid-email':
          mensagem = "Email inválido";
          break;
        case 'weak-password':
          mensagem = "Senha muito fraca (mínimo 6 caracteres)";
          break;
        default:
          mensagem = "Erro ao cadastrar usuário";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 233, 235),
      appBar: AppBar(
        title: const Text("Cadastro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // NOME
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nome de usuário",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um nome de usuário";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // EMAIL
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um email";
                  }
                  if (!value.contains("@")) {
                    return "Email inválido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // TELEFONE
              TextFormField(
                controller: _telController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um telefone";
                  }
                  if (int.tryParse(value) == null) {
                    return "Telefone inválido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // SENHA
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite uma senha";
                  }
                  if (value.length < 6) {
                    return "Mínimo 6 caracteres";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // CONFIRMAR SENHA
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmar senha",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirme a senha";
                  }
                  if (value != _passwordController.text) {
                    return "As senhas não coincidem";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // BOTÃO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text("Cadastrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}