
class Documento {
  final String id;
  final String titulo;
  final String conteudo;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'],
      titulo: map['titulo'],
      conteudo: map['conteudo'],
    );
  }
}
