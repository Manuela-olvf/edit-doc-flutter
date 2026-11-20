
import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();

  final TextEditingController _tituloController =
      TextEditingController();

  final TextEditingController _documentoController =
      TextEditingController();

  String? _documentoEmEdicaoId;

  @override
  void initState() {
    super.initState();
    _viewModel.carregarDocumentos();
  }

  Future<void> mostrarPreferencias() async {
    final preferencias =
        await _viewModel.consultarPreferencias();

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

  Future<void> salvarDocumento() async {
    final titulo = _tituloController.text.trim();
    final conteudo = _documentoController.text.trim();

    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o título e o conteúdo.'),
        ),
      );
      return;
    }

    final documento = Documento(
      id: _documentoEmEdicaoId ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
    );

    await _viewModel.salvarDocumento(documento);

    if (!mounted) return;

    _limparFormulario();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento salvo com sucesso!'),
      ),
    );
  }

  void abrirDocumento(Documento documento) {
    setState(() {
      _documentoEmEdicaoId = documento.id;
      _tituloController.text = documento.titulo;
      _documentoController.text = documento.conteudo;
    });
  }

  void _limparFormulario() {
    _documentoEmEdicaoId = null;
    _tituloController.clear();
    _documentoController.clear();
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

    await _viewModel.excluirDocumento(documento.id);

    if (!mounted) return;

    if (_documentoEmEdicaoId == documento.id) {
      _limparFormulario();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento excluído.'),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
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
                  'Leitor e Editor de Documentos',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título do documento',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _documentoController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo',
                    hintText: 'Digite seu documento...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: salvarDocumento,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _documentoEmEdicaoId == null
                        ? 'Salvar documento'
                        : 'Atualizar documento',
                  ),
                ),

                if (_documentoEmEdicaoId != null)
                  TextButton(
                    onPressed: _limparFormulario,
                    child: const Text('Cancelar edição'),
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

                if (_viewModel.carregando)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_viewModel.documentos.isEmpty)
                  const Text('Nenhum documento salvo.')
                else
                  ..._viewModel.documentos.map((documento) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(documento.titulo),
                        subtitle: Text(
                          documento.conteudo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => abrirDocumento(documento),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              excluirDocumento(documento),
                        ),
                      ),
                    );
                  }),
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
