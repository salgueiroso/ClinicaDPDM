import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:flutter/material.dart';

class MedicoItem implements ListItem {
  final int id;
  final String nome;
  final String crm;
  final EspecialidadeItem especialidade;

  MedicoItem({this.id, this.nome, this.crm, this.especialidade});

  factory MedicoItem.fromJson(Map<String, dynamic> json) {
    return MedicoItem(
        id: json['id'],
        nome: json['nome'],
        crm: json['crm'],
        //Especialidade: EspecialidadeItem.fromJson(json['especialidade'])
        especialidade: EspecialidadeItem(
          id: json['especialidade']['id'],
          nome: json['especialidade']['nome']
        )
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'nome': nome,
        'crm': crm,
        'especialidade': especialidade.toJson(),
      };

  Widget buildTitle(BuildContext context) => Text(
    this.nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => Text(
    'Especialidade: ${especialidade.nome}\nCRM: $crm',
    style: TextStyle(fontSize: 16),
  );

  bool isThreeLines() => true;
}