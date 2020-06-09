import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:flutter/material.dart';

class MedicoItem implements ListItem {
  final int Id;
  final String Nome;
  final String CRM;
  final EspecialidadeItem Especialidade;

  MedicoItem({this.Id, this.Nome, this.CRM, this.Especialidade});

  factory MedicoItem.fromJson(Map<String, dynamic> json) {
    return MedicoItem(
        Id: json['id'],
        Nome: json['nome'],
        CRM: json['crm'],
        //Especialidade: EspecialidadeItem.fromJson(json['especialidade'])
        Especialidade: EspecialidadeItem(
          Id: json['especialidade']['id'],
          Nome: json['especialidade']['nome']
        )
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': Id,
        'nome': Nome,
        'crm': CRM,
        'especialidade': Especialidade.toJson(),
      };

  Widget buildTitle(BuildContext context) => Text(
    this.Nome,
    style: TextStyle(fontSize: 25),
  );

  Widget buildSubtitle(BuildContext context) => Text(
    'Especialidade: ${Especialidade.Nome}\nCRM: $CRM',
    style: TextStyle(fontSize: 16),
  );

  bool isThreeLines() => true;
}