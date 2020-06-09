import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/cobertura.model.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/models/receita_medica.model.dart';
import 'package:flutter/material.dart';

class ConsultaItem implements ListItem {
  final int id;
  final DateTime dataHora;
  final CoberturaItem cobertura;
  final PacienteItem paciente;
  final List<ReceitaMedicaItem> receitasMedicas;

  ConsultaItem(
      {this.id,
      this.dataHora,
      this.cobertura,
      this.paciente,
      this.receitasMedicas});

  factory ConsultaItem.fromJson(Map<String, dynamic> json) {
    return ConsultaItem(
        id: json['id'],
        dataHora: DateTime.parse(json['dataHora'].toString()),
        cobertura: CoberturaItem.fromJson(json['cobertura']),
        paciente: PacienteItem.fromJson(json['paciente']),
        receitasMedicas: (json['receitasMedicas'] as List)
            .map((e) => ReceitaMedicaItem.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dataHora': dataHora.toIso8601String(),
        'cobertura': cobertura.toJson(),
        'paciente': paciente.toJson(),
        'receitasMedicas': receitasMedicas.map((e) => e.toJson()).toList()
      };

  Widget buildTitle(BuildContext context) => null;

  Widget buildSubtitle(BuildContext context) => null;

  bool isThreeLines() => false;
}
