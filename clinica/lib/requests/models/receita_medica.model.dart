import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/consulta.model.dart';
import 'package:flutter/material.dart';

class ReceitaMedicaItem implements ListItem {
  final int id;
  final String descricao;
  final DateTime data;
  final ConsultaItem consulta;

  ReceitaMedicaItem({this.id, this.descricao, this.data, this.consulta});

  factory ReceitaMedicaItem.fromJson(Map<String, dynamic> json) {
    return ReceitaMedicaItem(
        id: json['id'],
        descricao: json['descricao'],
        data: DateTime.parse(json['data'].toString()),
        consulta: ConsultaItem.fromJson(json['consulta']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'data': data.toIso8601String(),
        'consulta': consulta.toJson()
      };

  @override
  Widget buildSubtitle(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) => null;

  @override
  bool isThreeLines() => false;
}
