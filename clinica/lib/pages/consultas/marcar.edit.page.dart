import 'dart:convert';

import 'package:clinica/requests/models/cobertura.model.dart';
import 'package:clinica/requests/models/consulta.model.dart';
import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:clinica/widgets/dateformfield.dart';
import 'package:clinica/widgets/timeformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MarcacaoConsultaEditPage extends StatefulWidget {
  MarcacaoConsultaEditPage({Key key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _MarcacaoConsultaEditPage createState() => _MarcacaoConsultaEditPage();
}

class ConsultaRetData {
  final ConsultaItem consulta;
  final List<PacienteItem> pacientes;
  final List<CoberturaItem> coberturas;
  final List<EspecialidadeItem> especialidades;

  ConsultaRetData(
      {this.consulta, this.pacientes, this.coberturas, this.especialidades});
}

class _MarcacaoConsultaEditPage extends State<MarcacaoConsultaEditPage> {
  final dataController = TextEditingController();
  final timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose

    dataController.dispose();
    timeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.id == 0
              ? "Marcação de Consulta"
              : "Alterar Marcação de Consulta"),
        ),
        body: formularioWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save), onPressed: () => null));
  }

  Future<ConsultaItem> getConsulta(int id) async {
    if (widget.id != 0) {
      var response = await get("$URL_CONSULTAS_LISTAR/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var item = new ConsultaItem.fromJson(jsonResponse);
        return item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text('Erro ao obter a consulta! ${response.reasonPhrase}')));
      }
    }
    return ConsultaItem();
  }

  Future<List<PacienteItem>> getPacientes() async {
    if (widget.id != 0) {
      var response = await get("$URL_PACIENTES_LISTAR");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var item =
            jsonResponse.map((e) => new ConsultaItem.fromJson(e)).toList();

        return item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text('Erro ao obter pacientes! ${response.reasonPhrase}')));
      }
    }
    return List<PacienteItem>();
  }

  Future<List<CoberturaItem>> getCoberturas() async {
    if (widget.id != 0) {
      var response = await get("$URL_COBERTURAS_LIST");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var item =
            jsonResponse.map((e) => new CoberturaItem.fromJson(e)).toList();

        return item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text('Erro ao obter pacientes! ${response.reasonPhrase}')));
      }
    }
    return List<CoberturaItem>();
  }

  Future<List<DateTime>> getDHDisponiveis() async {
    var response = await get("$URL_CONSULTAS_LISTAR/datasHorasLivres");
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var item = jsonResponse.map((e) => DateTime.parse(e.toString())).toList();
      return item;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'Erro ao obter disponibilidades! ${response.reasonPhrase}')));
    }
    return List<DateTime>();
  }

  Future<ConsultaRetData> fetchData() async {
    var consulta = await getConsulta(widget.id);
    var pacientes = await getPacientes();
    var coberturas = await getCoberturas();
    return ConsultaRetData(
        consulta: consulta, pacientes: pacientes, coberturas: coberturas);
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
        child: FutureBuilder<ConsultaRetData>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(children: [
                    DateFormField(
                      dataController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Data de nascimento',
                          labelText: 'Nascimento'),
                      validator: (value) {
                        if (value.isEmpty) return "Informe um nome válido";
                        if (value.length <= 3)
                          return "Nome deve ser maior que 3 caracteres";
                        return null;
                      },
                    ),
                    TimeFormField(
                      timeController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Data de nascimento',
                          labelText: 'Nascimento'),
                      validator: (value) {
                        if (value.isEmpty) return "Informe um nome válido";
                        if (value.length <= 3)
                          return "Nome deve ser maior que 3 caracteres";
                        return null;
                      },
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
