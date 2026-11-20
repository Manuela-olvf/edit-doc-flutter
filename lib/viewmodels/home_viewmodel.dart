
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/services/usuario_service.dart';
import '../models/services/preferencias_service.dart';

class HomeViewModel extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  final PreferenciasService _preferenciasService =
      PreferenciasService();

  Future<List<Usuario>> listarUsuarios() async {
    return await _usuarioService.consultar();
  }

  Future<Map<String, dynamic>> consultarPreferencias() async {
    return await _preferenciasService.consultar();
  }
}

