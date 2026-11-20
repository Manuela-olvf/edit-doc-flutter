import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  Future<void> salvarTema(String tema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema', tema);
  }

  Future<void> salvarNotificacoes(bool ativo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificacoes', ativo);
  }

  Future<Map<String, dynamic>> consultar() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'tema': prefs.getString('tema') ?? 'Claro',
      'notificacoes': prefs.getBool('notificacoes') ?? true,
    };
  }
}