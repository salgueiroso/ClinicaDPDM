import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class EspecialidadeItem implements ListItem {
  final int id;
  final String nome;

  EspecialidadeItem({this.id, this.nome});

  factory EspecialidadeItem.fromJson(Map<String, dynamic> json) {
    return EspecialidadeItem(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'nome': nome
      };

  Widget buildTitle(BuildContext context) => Text(
    this.nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}