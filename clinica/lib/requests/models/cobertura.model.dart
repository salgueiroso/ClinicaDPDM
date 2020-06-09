import 'package:clinica/requests/models/base.model.dart';
import 'package:flutter/material.dart';

class CoberturaItem implements ListItem {
  final int Id;
  final String Nome;

  CoberturaItem(
      {this.Id,
        this.Nome});

  factory CoberturaItem.fromJson(Map<String, dynamic> json) {
    return CoberturaItem(
        Id: json['id'],
        Nome: json['nome']);
  }

  Map<String, dynamic> toJson() =>
      {
        'id': Id,
        'nome': Nome
      };

  Widget buildTitle(BuildContext context) => Text(
    Nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
