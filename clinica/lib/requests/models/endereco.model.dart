import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class EnderecoItem implements ListItem {
  final int Id;
  final String Rua;
  final String Bairro;
  final String Numero;

  EnderecoItem(
      {this.Id,
      this.Rua,
      this.Bairro,
      this.Numero});

  factory EnderecoItem.fromJson(Map<String, dynamic> json) {
    return EnderecoItem(
      Id: json['id'],
      Rua: json['rua'],
      Bairro: json['bairro'],
      Numero: json['numero'],
    );
  }

  @override
  String toString()=>"$Rua, $Numero, $Bairro";

  Map<String, dynamic> toJson() => {
        'id': Id,
        'rua': Rua,
        'bairro': Bairro,
        'numero': Numero,
      };

  Widget buildTitle(BuildContext context) => null;

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
