
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/services/usuario_service.dart';
import '../models/services/preferencias_service.dart';

class HomeViewModel extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  final PreferenciasService _preferenciasService =
      PreferenciasService();

  final List<String> documentos = [];

  String documentoAtual = '';

  void salvarDocumento(String texto) {
    final conteudo = texto.trim();

    if (conteudo.isEmpty) return;

    documentos.add(conteudo);
    documentoAtual = '';
    notifyListeners();
  }

  void abrirDocumento(String documento) {
    documentoAtual = documento;
    notifyListeners();
  }

  Future<List<Usuario>> listarUsuarios() async {
    return await _usuarioService.consultar();
  }

  Future<Map<String, dynamic>> consultarPreferencias() async {
    return await _preferenciasService.consultar();
  }
}
