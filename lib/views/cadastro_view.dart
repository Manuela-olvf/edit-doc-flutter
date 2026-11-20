
import 'package:flutter/material.dart';
import '../viewmodels/cadastro_viewmodel.dart';
import '../utils/validadores.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final CadastroViewModel _viewModel = CadastroViewModel();

  Future<void> cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final cadastrado = await _viewModel.cadastrarUsuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    if (!cadastrado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este e-mail já está cadastrado.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: _nomeController.text.trim(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 70,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarNome,
                  ),
                  const SizedBox(height: 16),
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
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarSenha,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Preferência de tema',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioGroup<String>(
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (value) {
                      if (value != null) {
                        _viewModel.alterarTema(value);
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Claro'),
                          value: 'Claro',
                        ),
                        RadioListTile<String>(
                          title: const Text('Escuro'),
                          value: 'Escuro',
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Ativar notificações'),
                    value: _viewModel.notificacoesAtivas,
                    onChanged: _viewModel.alterarNotificacoes,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _viewModel.carregando
                        ? null
                        : cadastrarUsuario,
                    child: _viewModel.carregando
                        ? const CircularProgressIndicator()
                        : const Text('Cadastrar'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
