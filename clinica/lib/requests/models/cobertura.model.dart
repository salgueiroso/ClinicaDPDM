import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class CoberturaItem implements ListItem {
  final int id;
  final String nome;

  CoberturaItem(
      {this.id,
        this.nome});

  factory CoberturaItem.fromJson(Map<String, dynamic> json) {
    return CoberturaItem(
        id: json['id'],
        nome: json['nome']);
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'nome': nome
      };

  Widget buildTitle(BuildContext context) => Text(
    nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
