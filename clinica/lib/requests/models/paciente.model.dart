import 'package:clinica/requests/models/base.model.dart';
import 'package:clinica/requests/models/endereco.model.dart';
import 'package:flutter/material.dart';

class PacienteItem implements ListItem {
  final int Id;
  final String Nome;
  final DateTime DataNascimento;
  final int Telefone;
  final int RG;
  final int CPF;
  final String Login;
  final String Senha;
  final EnderecoItem Endereco;

  PacienteItem(
      {this.Id,
      this.Nome,
      this.DataNascimento,
      this.Telefone,
      this.RG,
      this.CPF,
      this.Login,
      this.Senha,
      this.Endereco});

  factory PacienteItem.fromJson(Map<String, dynamic> json) {
    return PacienteItem(
      Id: json['id'],
      Nome: json['nome'],
      DataNascimento: DateTime.parse(json['dataNascimento'].toString()),
      Telefone: json['telefone'],
      RG: json['rg'],
      CPF: json['cpf'],
      Login: json['login'],
      Senha: json['senha'],
      Endereco: EnderecoItem(
        Id: json['endereco']['id'],
        Bairro: json['endereco']['bairro'],
        Rua: json['endereco']['rua'],
        Numero: json['endereco']['numero'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'nome': Nome,
        'dataNascimento': DataNascimento.toIso8601String(),
        'telefone': Telefone,
        'rg': RG,
        'cpf': CPF,
        'login': Login,
        'senha': Senha,
        'endereco': Endereco.toJson()
      };

  Widget buildTitle(BuildContext context) => Text(
        this.Nome,
        style: TextStyle(fontSize: 25),
      );

  Widget buildSubtitle(BuildContext context) => Text(
        'Login: $Login\nNascimento: $DataNascimento\nTelefone: $Telefone\nRG: $RG\nCPF: $CPF\nEndereço: ${Endereco.toString()}',
        style: TextStyle(fontSize: 16),
      );

  bool isThreeLines() => true;
}
