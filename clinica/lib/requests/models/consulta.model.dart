import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/cobertura.model.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/models/receita_medica.model.dart';
import 'package:flutter/material.dart';

class ConsultaItem implements ListItem {
  final int Id;
  final DateTime DataHora;
  final CoberturaItem Cobertura;
  final PacienteItem Paciente;
  final List<ReceitaMedicaItem> ReceitasMedicas;

  ConsultaItem(
      {this.Id,
      this.DataHora,
      this.Cobertura,
      this.Paciente,
      this.ReceitasMedicas});

  factory ConsultaItem.fromJson(Map<String, dynamic> json) {
    return ConsultaItem(
        Id: json['id'],
        DataHora: DateTime.parse(json['dataHora'].toString()),
        Cobertura: CoberturaItem.fromJson(json['cobertura']),
        Paciente: PacienteItem.fromJson(json['paciente']),
        ReceitasMedicas: (json['receitasMedicas'] as List)
            .map((e) => ReceitaMedicaItem.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'dataHora': DataHora.toIso8601String(),
        'cobertura': Cobertura.toJson(),
        'paciente': Paciente.toJson(),
        'receitasMedicas': ReceitasMedicas.map((e) => e.toJson()).toList()
      };

  Widget buildTitle(BuildContext context) => null;

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
