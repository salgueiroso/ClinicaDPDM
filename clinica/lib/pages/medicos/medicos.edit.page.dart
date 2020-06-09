import 'dart:convert';

import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:clinica/requests/models/medico.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MedicosEditPage extends StatefulWidget {
  MedicosEditPage({Key key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _MedicosEditPage createState() => _MedicosEditPage();
}

class MedicosRetData {
  final List<DropdownMenuItem<int>> Especialidades;
  final MedicoItem Medico;

  MedicosRetData({this.Especialidades, this.Medico});
}

class _MedicosEditPage extends State<MedicosEditPage> {
  final nomeController = new TextEditingController();
  final crmController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int especialidade;

  @override
  void dispose() {
    // TODO: implement dispose
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.id == 0 ? "Médico - Novo" : "Médico - Alteração"),
        ),
        body: FormularioWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save), onPressed: () => saveMedico()));
  }

  Future saveMedico() async {
    if (!_formKey.currentState.validate()) return null;

    MedicoItem medico;
    if (widget.id == 0)
      medico = MedicoItem(
          Nome: nomeController.text,
          CRM: crmController.text,
          Especialidade: EspecialidadeItem(Id: especialidade, Nome: ''));
    else
      medico = MedicoItem(
          Id: widget.id,
          Nome: nomeController.text,
          CRM: crmController.text,
          Especialidade: EspecialidadeItem(Id: especialidade, Nome: ''));

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(medico);
    Response response;
    if (widget.id != 0)
      response = await put("$URL_MEDICOS_LISTAR", headers: headers, body: body);
    else
      response =
          await post("$URL_MEDICOS_LISTAR", headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao salvar médico! ${response.reasonPhrase}')));
    }
  }

  Future<MedicoItem> getMedico(int id) async {
    if (widget.id != 0) {
      var response = await get("$URL_MEDICOS_LISTAR/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var item = new MedicoItem.fromJson(jsonResponse);
        return item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text('Erro ao obter os médicos! ${response.reasonPhrase}')));
      }
    }
    return null;
  }

  Future<List<DropdownMenuItem<int>>> getEspecialidades() async {
    var response = await get("$URL_ESPECIALIDADES_LISTAR");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
          jsonResponse.map((a) => new EspecialidadeItem.fromJson(a)).toList();

      return _items
          .map((e) => DropdownMenuItem<int>(
                child: Text(e.Nome),
                value: e.Id,
              ))
          .toList();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text('Erro ao obter especialidades! ${response.reasonPhrase}')));
    }

    return null;
  }

  Future<MedicosRetData> fetchData() async {
    return MedicosRetData(
        Especialidades: await getEspecialidades(),
        Medico: await getMedico(widget.id));
  }

  Widget FormularioWidget() {
    return Form(
        key: _formKey,
        child: FutureBuilder<MedicosRetData>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              nomeController.text = snapshot.data.Medico?.Nome;
              crmController.text = snapshot.data.Medico?.CRM;
              return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: [
                    TextFormField(
                      controller: nomeController,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um nome válido";
                        if (value.length <= 3)
                          return "Nome deve ser maior que 3 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Nome do médico',
                          labelText: 'Nome *'),
                    ),
                    TextFormField(
                      controller: crmController,
                      validator: (value) {
                        if (value.isEmpty) return "Informe um CRM válido";
                        if (value.length <= 4)
                          return "CRM deve ser maior que 4 caracteres";
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'CRM do médico',
                          labelText: 'CRM *'),
                    ),
                    DropdownButtonFormField(
                      value: snapshot.data.Medico?.Especialidade?.Id,
                      items: snapshot.data.Especialidades,
                      onChanged: (newVal) {
                        setState(() {
                          especialidade = newVal;
                        });
                      },
                      validator: (value) {
                        if (value == null) return "Informa uma especialidade";
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Especialidade do médico',
                          labelText: 'Especialidade *'),
                    )
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
