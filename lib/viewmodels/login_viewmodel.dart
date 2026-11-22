
import 'package:flutter/material.dart';
import '../models/services/usuario_service.dart';
import '../models/services/preferencias_service.dart';
import '../models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  final PreferenciasService _preferenciasService =
      PreferenciasService();

  bool carregando = false;
  bool ocultarSenha = true;

  void alternarVisibilidadeSenha() {
    ocultarSenha = !ocultarSenha;
    notifyListeners();
  }

  Future<Usuario?> realizarLogin(String email, String senha) async {
    carregando = true;
    notifyListeners();

    try {
      final loginValido =
          await _usuarioService.verificarLogin(email, senha);

      if (!loginValido) {
        return null;
      }

      final usuarios = await _usuarioService.consultar();

      final usuario = usuarios.firstWhere(
        (usuario) =>
            usuario.email.toLowerCase() == email.toLowerCase(),
      );

      await _preferenciasService.salvarSessao(
        usuario.nome,
        usuario.email,
      );

      return usuario;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
