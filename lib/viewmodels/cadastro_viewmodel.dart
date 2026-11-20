import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/services/usuario_service.dart';
import '../models/services/preferencias_service.dart';
import '../utils/tema_global.dart';

class CadastroViewModel extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  final PreferenciasService _preferenciasService = PreferenciasService();

  String temaSelecionado = 'Claro';
  bool notificacoesAtivas = true;
  bool carregando = false;

  void alterarTema(String tema) {
    temaSelecionado = tema;
    notifyListeners();
  }

  void alterarNotificacoes(bool ativo) {
    notificacoesAtivas = ativo;
    notifyListeners();
  }

  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      final usuario = Usuario(
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
      );

      final cadastrado = await _usuarioService.inserir(usuario);

      if (!cadastrado) {
        return false;
      }

      await _preferenciasService.salvarTema(temaSelecionado);
  await _preferenciasService.salvarNotificacoes(
  notificacoesAtivas,
);

temaGlobal.value = temaSelecionado;

return true;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}