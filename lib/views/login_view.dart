
import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';
import '../utils/validadores.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final LoginViewModel _viewModel = LoginViewModel();

  Future<void> realizarLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = await _viewModel.realizarLogin(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    if (usuario != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: usuario.nome,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 90,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: _viewModel.ocultarSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.ocultarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _viewModel
                              .alternarVisibilidadeSenha,
                        ),
                      ),
                      validator: validarSenha,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _viewModel.carregando
                            ? null
                            : realizarLogin,
                        child: _viewModel.carregando
                            ? const CircularProgressIndicator()
                            : const Text('Entrar'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastro');
                      },
                      child: const Text('Criar uma conta'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
