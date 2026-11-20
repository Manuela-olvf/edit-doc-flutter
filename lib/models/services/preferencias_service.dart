class PreferenciasService {
  static final Map<String, dynamic> _preferencias = {
    'tema': 'Claro',
    'notificacoes': true,
  };

  Future<void> salvarTema(String tema) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _preferencias['tema'] = tema;
  }

  Future<void> salvarNotificacoes(bool ativo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _preferencias['notificacoes'] = ativo;
  }

  Future<Map<String, dynamic>> consultar() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Map<String, dynamic>.from(_preferencias);
  }
}