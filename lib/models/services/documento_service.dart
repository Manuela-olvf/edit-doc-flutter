
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../documento.dart';

class DocumentoService {
  static const String _chave = 'documentos';

  Future<List<Documento>> consultar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(_chave);

    if (dados == null) {
      return [];
    }

    final List<dynamic> lista = jsonDecode(dados);

    return lista
        .map((item) => Documento.fromMap(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Future<void> salvar(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = jsonEncode(
      documentos.map((documento) => documento.toMap()).toList(),
    );

    await prefs.setString(_chave, dados);
  }
}
