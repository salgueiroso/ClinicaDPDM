import 'dart:convert';

import 'package:clinica/requests/models/endereco.model.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PacientesEditPage extends StatefulWidget {
  PacientesEditPage({Key key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _PacientesEditPage createState() => _PacientesEditPage();
}

class PacienteRetData {
  final PacienteItem paciente;

  PacienteRetData({this.paciente});
}

class _PacientesEditPage extends State<PacientesEditPage> {
  final nomeController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final telefoneController = TextEditingController();
  final rgController = TextEditingController();
  final cpfController = TextEditingController();
  final loginController = TextEditingController();
  final senhaController = TextEditingController();
  final bairroController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final idEnderecoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose

    nomeController.dispose();
    dataNascimentoController.dispose();
    telefoneController.dispose();
    rgController.dispose();
    cpfController.dispose();
    loginController.dispose();
    senhaController.dispose();
    bairroController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    idEnderecoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:
              Text(widget.id == 0 ? "Paciente - Novo" : "Paciente - Alteração"),
        ),
        body: formularioWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save), onPressed: () => savePaciente()));
  }

  Future savePaciente() async {
    if (!_formKey.currentState.validate()) return null;

    PacienteItem paciente;
    if (widget.id == 0)
      paciente = PacienteItem(
          nome: nomeController.text,
          dataNascimento: DateTime.parse(dataNascimentoController.text),
          cpf: int.parse(cpfController.text),
          rg: int.parse(rgController.text),
          telefone: int.parse(telefoneController.text),
          login: loginController.text,
          senha: senhaController.text,
          endereco: EnderecoItem(
            bairro: bairroController.text,
            rua: ruaController.text,
            numero: numeroController.text,
          ));
    else
      paciente = PacienteItem(
          id: widget.id,
          nome: nomeController.text,
          dataNascimento: DateTime.parse(dataNascimentoController.text),
          cpf: int.parse(cpfController.text),
          rg: int.parse(rgController.text),
          telefone: int.parse(telefoneController.text),
          //Login: loginController.text,
          senha: senhaController.text,
          endereco: EnderecoItem(
            id: int.parse(idEnderecoController.text),
            bairro: bairroController.text,
            rua: ruaController.text,
            numero: numeroController.text,
          ));

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(paciente);
    Response response;
    if (widget.id != 0)
      response =
          await put("$URL_PACIENTES_LISTAR", headers: headers, body: body);
    else
      response =
          await post("$URL_PACIENTES_LISTAR", headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao salvar paciente! ${response.reasonPhrase}')));
    }
  }

  Future<PacienteItem> getPaciente(int id) async {
    if (widget.id != 0) {
      var response = await get("$URL_PACIENTES_LISTAR/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var item = new PacienteItem.fromJson(jsonResponse);
        return item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Erro ao obter o médico! ${response.reasonPhrase}')));
      }
    }
    return null;
  }

  Future<PacienteRetData> fetchData() async {
    return PacienteRetData(paciente: await getPaciente(widget.id));
  }

  Future<DateTime> selectDate(BuildContext _context, DateTime initial) async {
    return await showDatePicker(
        context: _context,
        initialDate: initial ?? DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
  }

  Widget formularioWidget() {
    return Form(
        key: _formKey,
        child: FutureBuilder<PacienteRetData>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              nomeController.text = snapshot.data.paciente?.nome ?? "";
              dataNascimentoController.text =
                  snapshot.data.paciente?.dataNascimento?.toIso8601String() ??
                      "";
              telefoneController.text =
                  snapshot.data.paciente?.telefone?.toString() ?? "";
              rgController.text = snapshot.data.paciente?.rg?.toString() ?? "";
              cpfController.text =
                  snapshot.data.paciente?.cpf?.toString() ?? "";
              loginController.text =
                  snapshot.data.paciente?.login?.toString() ?? "";
              bairroController.text =
                  snapshot.data.paciente?.endereco?.bairro ?? "";
              ruaController.text = snapshot.data.paciente?.endereco?.rua ?? "";
              numeroController.text =
                  snapshot.data.paciente?.endereco?.numero ?? "";
              idEnderecoController.text =
                  snapshot.data.paciente?.endereco?.id?.toString() ?? "";

              return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(children: [
                    Container(
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Conta',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    TextFormField(
                      controller: loginController,
                      readOnly: widget.id != 0,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um login válido";
                        if (value.length <= 3)
                          return "Login deve ser maior que 3 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Login do paciente', labelText: 'Login *'),
                    ),
                    TextFormField(
                      controller: senhaController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (widget.id != 0 && value.isEmpty) return null;
                        if (value.isEmpty) return "Informe uma senha válida";
                        if (value.length <= 5)
                          return "Senha deve ser maior que 5 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Senha do paciente', labelText: 'Senha *'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dados Pessoais',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    TextFormField(
                      controller: nomeController,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um nome válido";
                        if (value.length <= 3)
                          return "Nome deve ser maior que 3 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Nome do paciente', labelText: 'Nome *'),
                    ),
                    TextFormField(
                      controller: dataNascimentoController,
                      onTap: () => selectDate(
                              context, snapshot.data.paciente?.dataNascimento)
                          .then((value) => dataNascimentoController.text =
                              value.toIso8601String()),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value.isEmpty) return "Informe uma data válida";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Data de Nascimento',
                          labelText: 'Nascimento *'),
                    ),
                    TextFormField(
                      controller: telefoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um Telefone válido";
                        if (value.length <= 4)
                          return "Telefone deve ser maior que 4 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Telefone do paciente',
                          labelText: 'Telefone *'),
                    ),
                    TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um CPF válido";
                        if (value.length <= 4)
                          return "CPF deve ser maior que 11 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'CPF do paciente', labelText: 'CPF *'),
                    ),
                    TextFormField(
                      controller: rgController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um RG válido";
                        if (value.length <= 4)
                          return "RG deve ser maior que 4 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'RG do paciente', labelText: 'RG *'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Endereço',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    TextFormField(
                      controller: ruaController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Informe a rua";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Rua', labelText: 'Rua *'),
                    ),
                    TextFormField(
                      controller: numeroController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Informe o numero";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Numero', labelText: 'Numero *'),
                    ),
                    TextFormField(
                      controller: bairroController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Informe o bairro";
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Bairro', labelText: 'Bairro *'),
                    ),
                  ]));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: fetchData(),
        ));
  }
}
