
import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();
  final DocumentosViewModel _documentosViewModel =
      DocumentosViewModel();

  @override
  void initState() {
    super.initState();
    _documentosViewModel.carregarDocumentos();
  }

  Future<void> mostrarPreferencias() async {
    final preferencias = await _viewModel.consultarPreferencias();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Minhas preferências'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tema: ${preferencias['tema']}'),
            const SizedBox(height: 12),
            Text(
              'Notificações: ${preferencias['notificacoes'] == true ? 'Ativadas' : 'Desativadas'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> listarUsuarios() async {
    final usuarios = await _viewModel.listarUsuarios();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuários cadastrados'),
        content: SizedBox(
          width: double.maxFinite,
          child: usuarios.isEmpty
              ? const Text('Nenhum usuário cadastrado.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];

                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(usuario.nome),
                      subtitle: Text(usuario.email),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> excluirDocumento(Documento documento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento'),
        content: Text(
          'Deseja realmente excluir "${documento.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _documentosViewModel.excluirDocumento(documento.id);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _documentosViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nome =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página inicial'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Olá, $nome!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Bem-vindo à sua área de usuário.'),
            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Minhas preferências'),
                subtitle: const Text(
                  'Consultar tema e notificações',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: mostrarPreferencias,
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Usuários cadastrados'),
                subtitle: const Text(
                  'Visualizar a lista de usuários',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: listarUsuarios,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Meus documentos',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/editor').then((_) {
                  _documentosViewModel.carregarDocumentos();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Criar documento'),
            ),

            const SizedBox(height: 16),

            ListenableBuilder(
              listenable: _documentosViewModel,
              builder: (context, child) {
                if (_documentosViewModel.carregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_documentosViewModel.documentos.isEmpty) {
                  return const Text('Nenhum documento salvo.');
                }

                return Column(
                  children: _documentosViewModel.documentos.map((documento) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(documento.titulo),
                        subtitle: Text(
                          documento.conteudo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/editor',
                            arguments: documento,
                          ).then((_) {
                            _documentosViewModel.carregarDocumentos();
                          });
                        },
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => excluirDocumento(documento),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(14),
        child: Text(
          'Desenvolvido por: Manuela Figueira',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
