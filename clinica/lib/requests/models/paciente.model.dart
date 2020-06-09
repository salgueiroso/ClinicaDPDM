import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/endereco.model.dart';
import 'package:flutter/material.dart';

class PacienteItem implements ListItem {
  final int id;
  final String nome;
  final DateTime dataNascimento;
  final int telefone;
  final int rg;
  final int cpf;
  final String login;
  final String senha;
  final EnderecoItem endereco;

  PacienteItem(
      {this.id,
      this.nome,
      this.dataNascimento,
      this.telefone,
      this.rg,
      this.cpf,
      this.login,
      this.senha,
      this.endereco});

  factory PacienteItem.fromJson(Map<String, dynamic> json) {
    return PacienteItem(
      id: json['id'],
      nome: json['nome'],
      dataNascimento: DateTime.parse(json['dataNascimento'].toString()),
      telefone: json['telefone'],
      rg: json['rg'],
      cpf: json['cpf'],
      login: json['login'],
      senha: json['senha'],
      endereco: EnderecoItem(
        id: json['endereco']['id'],
        bairro: json['endereco']['bairro'],
        rua: json['endereco']['rua'],
        numero: json['endereco']['numero'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'dataNascimento': dataNascimento.toIso8601String(),
        'telefone': telefone,
        'rg': rg,
        'cpf': cpf,
        'login': login,
        'senha': senha,
        'endereco': endereco.toJson()
      };

  Widget buildTitle(BuildContext context) => Text(
        this.nome,
        style: TextStyle(fontSize: 25),
      );

  Widget buildSubtitle(BuildContext context) => Text(
        'Login: $login\nNascimento: $dataNascimento\nTelefone: $telefone\nRG: $rg\nCPF: $cpf\nEndereço: ${endereco.toString()}',
        style: TextStyle(fontSize: 16),
      );

  bool isThreeLines() => true;
}
