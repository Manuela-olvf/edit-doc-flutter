
import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  const EditorView({super.key});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final DocumentosViewModel _viewModel = DocumentosViewModel();

  final TextEditingController _tituloController =
      TextEditingController();

  final TextEditingController _conteudoController =
      TextEditingController();

  Documento? _documentoEmEdicao;
  bool _carregando = true;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_documentoEmEdicao == null) {
      final argumento = ModalRoute.of(context)?.settings.arguments;

      if (argumento is Documento) {
        _documentoEmEdicao = argumento;
        _tituloController.text = argumento.titulo;
        _conteudoController.text = argumento.conteudo;
      }

      _carregarDocumentos();
    }
  }

  Future<void> _carregarDocumentos() async {
    await _viewModel.carregarDocumentos();

    if (mounted) {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _salvarDocumento() async {
    final titulo = _tituloController.text.trim();
    final conteudo = _conteudoController.text.trim();

    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o título e o conteúdo.'),
        ),
      );
      return;
    }

    setState(() {
      _salvando = true;
    });

    final documento = Documento(
      id: _documentoEmEdicao?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
    );

    try {
      await _viewModel.salvarDocumento(documento);

      if (!mounted) return;

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _documentoEmEdicao == null
              ? 'Criar documento'
              : 'Editar documento',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do documento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _conteudoController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Conteúdo',
                hintText: 'Digite seu documento...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _salvando ? null : _salvarDocumento,
              icon: const Icon(Icons.save),
              label: Text(
                _salvando ? 'Salvando...' : 'Salvar documento',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
