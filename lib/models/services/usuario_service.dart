import '../usuario.dart';

class UsuarioService {
  static final List<Usuario> _usuarios = [];

  Future<bool> inserir(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final emailExiste = _usuarios.any(
      (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
    );

    if (emailExiste) {
      return false;
    }

    _usuarios.add(usuario);
    return true;
  }

  Future<List<Usuario>> consultar() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Usuario>.from(_usuarios);
  }

  Future<bool> verificarLogin(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _usuarios.any(
      (u) =>
          u.email.toLowerCase() == email.toLowerCase() &&
          u.senha == senha,
    );
  }
}