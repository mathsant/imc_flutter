class IMC {
  final double altura;
  final double peso;
  final String mensagem;

  IMC(this.altura, this.peso, this.mensagem);

  factory IMC.fromJson(Map json) {
    return IMC(json["altura"], json["peso"], json["mensagem"]);
  }

  @override
  String toString() {
    return "Altura: $altura | Peso: $peso | Mensagem: $mensagem";
  }
}
