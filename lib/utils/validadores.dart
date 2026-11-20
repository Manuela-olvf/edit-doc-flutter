
String? validarNome(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe seu nome';
  }
  return null;
}

String? validarEmail(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe seu e-mail';
  }

  final email = valor.trim();

  if (!email.contains('@') || email.split('@').length != 2) {
    return 'E-mail inválido';
  }

  final partes = email.split('@');
  final usuario = partes[0];
  final dominio = partes[1];

  if (usuario.isEmpty ||
      dominio.isEmpty ||
      !(dominio.endsWith('.com') ||
          dominio.endsWith('.com.br'))) {
    return 'O e-mail deve terminar em .com ou .com.br';
  }

  return null;
}

String? validarSenha(String? valor) {
  if (valor == null || valor.isEmpty) {
    return 'Informe sua senha';
  }

  if (valor.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }

  return null;
}
