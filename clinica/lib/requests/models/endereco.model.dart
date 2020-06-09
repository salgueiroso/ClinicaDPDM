import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class EnderecoItem implements ListItem {
  final int id;
  final String rua;
  final String bairro;
  final String numero;

  EnderecoItem(
      {this.id,
      this.rua,
      this.bairro,
      this.numero});

  factory EnderecoItem.fromJson(Map<String, dynamic> json) {
    return EnderecoItem(
      id: json['id'],
      rua: json['rua'],
      bairro: json['bairro'],
      numero: json['numero'],
    );
  }

  @override
  String toString()=>"$rua, $numero, $bairro";

  Map<String, dynamic> toJson() => {
        'id': id,
        'rua': rua,
        'bairro': bairro,
        'numero': numero,
      };

  Widget buildTitle(BuildContext context) => null;

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
