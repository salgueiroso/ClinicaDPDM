import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/consulta.model.dart';
import 'package:flutter/material.dart';

class ReceitaMedicaItem implements ListItem {
  final int Id;
  final String Descricao;
  final DateTime Data;
  final ConsultaItem Consulta;

  ReceitaMedicaItem({this.Id, this.Descricao, this.Data, this.Consulta});

  factory ReceitaMedicaItem.fromJson(Map<String, dynamic> json) {
    return ReceitaMedicaItem(
        Id: json['id'],
        Descricao: json['descricao'],
        Data: DateTime.parse(json['data'].toString()),
        Consulta: ConsultaItem.fromJson(json['consulta']));
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'descricao': Descricao,
        'data': Data.toIso8601String(),
        'consulta': Consulta.toJson()
      };

  @override
  Widget buildSubtitle(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) => null;

  @override
  bool isThreeLines() => false;
}
