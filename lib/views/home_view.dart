
import 'package:flutter/material.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();
  final TextEditingController _documentoController =
      TextEditingController();

  Future<void> mostrarPreferencias() async {
    final preferencias =
        await _viewModel.consultarPreferencias();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  Future<void> listarUsuarios() async {
    final usuarios = await _viewModel.listarUsuarios();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void salvarDocumento() {
    if (_documentoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite algo antes de salvar.'),
        ),
      );
      return;
    }

    _viewModel.salvarDocumento(_documentoController.text);
    _documentoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento salvo com sucesso!'),
      ),
    );
  }

  void abrirDocumento(String documento) {
    _viewModel.abrirDocumento(documento);
    _documentoController.text = documento;
  }

  @override
  void dispose() {
    _documentoController.dispose();
    _viewModel.dispose();
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
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return Column(
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
                const Text(
                  'Bem-vindo à sua área de usuário.',
                ),
                const SizedBox(height: 24),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    title: const Text('Minhas preferências'),
                    subtitle: const Text(
                      'Consultar tema e notificações',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: mostrarPreferencias,
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.people,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    title: const Text('Usuários cadastrados'),
                    subtitle: const Text(
                      'Visualizar a lista de usuários',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: listarUsuarios,
                  ),
                ),

                const SizedBox(height: 28),
                const Text(
                  'Leitor e Editor de Documentos',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _documentoController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Digite ou edite seu documento...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: salvarDocumento,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar documento'),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Documentos salvos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (_viewModel.documentos.isEmpty)
                  const Text('Nenhum documento salvo.')
                else
                  ..._viewModel.documentos.asMap().entries.map(
                    (entrada) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            'Documento ${entrada.key + 1}',
                          ),
                          subtitle: Text(
                            entrada.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            abrirDocumento(entrada.value);
                          },
                        ),
                      );
                    },
                  ),
              ],
            );
          },
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
