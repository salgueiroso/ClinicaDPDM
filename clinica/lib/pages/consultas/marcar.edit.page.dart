import 'dart:convert';

import 'package:clinica/requests/models/cobertura.model.dart';
import 'package:clinica/requests/models/consulta.model.dart';
import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:clinica/requests/models/medico.model.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MarcacaoConsultaEditPage extends StatefulWidget {
  MarcacaoConsultaEditPage({Key key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _MarcacaoConsultaEditPage createState() => _MarcacaoConsultaEditPage();
}

class _MarcacaoConsultaEditPage extends State<MarcacaoConsultaEditPage> {
  final especialidadeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _especialidadeSelecionada;
  List<EspecialidadeItem> _especialidades;
  int _medicoSelecionado;
  List<MedicoItem> _medicos;

  Widget _widgetEspecialidades;

  @override
  void dispose() {
    // TODO: implement dispose

    especialidadeController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _especialidades = [];
    _medicos = [];

    fetchEspecialidades().then((value) => setState(() {
          _especialidades = value;
          _widgetEspecialidades = GetWidgetEspecialidades();
        }));

    super.initState();
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

  Future<List<EspecialidadeItem>> fetchEspecialidades() async {
    var response = await get("$URL_ESPECIALIDADES_LISTAR");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
          jsonResponse.map((a) => new EspecialidadeItem.fromJson(a)).toList();

      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text('Erro ao obter especialidades! ${response.reasonPhrase}')));
    }

    return null;
  }

  Future<List<MedicoItem>> fetchMedicosPorEspecialidade(
      int especialidadeId) async {
    especialidadeId = especialidadeId ?? 0;
    var response =
        await get("$URL_MEDICOS_LISTAR_POR_ESPECIALIDADE$especialidadeId");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items = jsonResponse.map((a) => new MedicoItem.fromJson(a)).toList();

      _items.insert(0, MedicoItem(id: null, nome: ''));

      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao obter medicos! ${response.reasonPhrase}')));
    }

    return null;
  }

  Widget formularioWidget() {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(children: [
              _widgetEspecialidades,
              DropdownButtonFormField<int>(
                items: _medicos
                    .map((e) => DropdownMenuItem<int>(
                          child: Text(e.nome),
                          value: e.id,
                        ))
                    .toList(),
                value: _medicoSelecionado,
                onChanged: (v) => setState(() {
                  _medicoSelecionado = v;
                }),
                decoration: const InputDecoration(
                    hintText: 'Informe o médico', labelText: 'Médico *'),
              ),
            ])));
  }

  Widget GetWidgetEspecialidades() {
    return DropdownButtonFormField(
      items: _especialidades
          .map((e) => DropdownMenuItem<int>(
                child: Text(e.nome),
                value: e.id,
              ))
          .toList(),
      value: _especialidadeSelecionada,
      onChanged: (v) {
        fetchMedicosPorEspecialidade(v).then((value) => setState(() {
              _medicos = value;
              _especialidadeSelecionada = v;
            }));
      },
      decoration: const InputDecoration(
          hintText: 'Informe a especialidade', labelText: 'Especialidade *'),
    );
  }
}
