
import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../models/services/documento_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoService _documentoService = DocumentoService();

  List<Documento> documentos = [];
  bool carregando = false;

  Future<void> carregarDocumentos() async {
    carregando = true;
    notifyListeners();

    try {
      documentos = await _documentoService.consultar();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarDocumento(Documento documento) async {
    final indice = documentos.indexWhere(
      (item) => item.id == documento.id,
    );

    if (indice >= 0) {
      documentos[indice] = documento;
    } else {
      documentos.add(documento);
    }

    await _documentoService.salvar(documentos);
    notifyListeners();
  }

  Future<void> excluirDocumento(String id) async {
    documentos.removeWhere((documento) => documento.id == id);

    await _documentoService.salvar(documentos);
    notifyListeners();
  }
}
