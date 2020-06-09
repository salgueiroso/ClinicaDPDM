import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class EspecialidadeItem implements ListItem {
  final int Id;
  final String Nome;

  EspecialidadeItem({this.Id, this.Nome});

  factory EspecialidadeItem.fromJson(Map<String, dynamic> json) {
    return EspecialidadeItem(
      Id: json['id'],
      Nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': Id,
        'nome': Nome
      };

  Widget buildTitle(BuildContext context) => Text(
    this.Nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}