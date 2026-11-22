
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  // Salvar tema
  Future<void> salvarTema(String tema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema', tema);
  }

  // Salvar notificações
  Future<void> salvarNotificacoes(bool ativo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificacoes', ativo);
  }

  // Consultar preferências
  Future<Map<String, dynamic>> consultar() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'tema': prefs.getString('tema') ?? 'Claro',
      'notificacoes': prefs.getBool('notificacoes') ?? true,
    };
  }

  // Salvar sessão do usuário
  Future<void> salvarSessao(String nome, String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('usuario_nome', nome);
    await prefs.setString('usuario_email', email);
  }

  // Consultar sessão do usuário
  Future<Map<String, String?>> consultarSessao() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'nome': prefs.getString('usuario_nome'),
      'email': prefs.getString('usuario_email'),
    };
  }

  // Encerrar sessão
  Future<void> encerrarSessao() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('usuario_nome');
    await prefs.remove('usuario_email');
  }
}
