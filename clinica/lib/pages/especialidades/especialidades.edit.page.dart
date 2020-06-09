import 'dart:convert';

import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EspecialidadesEditPage extends StatefulWidget {
  EspecialidadesEditPage({Key key, this.id = 0}) : super(key: key);

  final int id;

  @override
  _EspecialidadesEditPage createState() => _EspecialidadesEditPage();
}

class _EspecialidadesEditPage extends State<EspecialidadesEditPage> {
  final nomeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          title: Text(widget.id == 0 ? "Especialidade - Novo" : "Especialidade - Alteração"),
        ),
        body: formularioWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save), onPressed: () => saveEspecialdiade()));
  }

  Future saveEspecialdiade() async {
    if (!_formKey.currentState.validate()) return null;

    EspecialidadeItem espec;
    if (widget.id == 0)
      espec = EspecialidadeItem(nome: nomeController.text);
    else
      espec = EspecialidadeItem(
          id: widget.id, nome: nomeController.text);

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(espec);
    Response response;
    if (widget.id != 0)
      response =
          await put("$URL_ESPECIALIDADES_LISTAR", headers: headers, body: body);
    else
      response = await post("$URL_ESPECIALIDADES_LISTAR",
          headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text('Erro ao salvar especialidade! ${response.reasonPhrase}')));
    }
  }

  Future getEspecialidade() async {
    if (widget.id != 0) {
      var response =
          await get("$URL_ESPECIALIDADES_LISTAR/${widget.id}");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var _item = new EspecialidadeItem.fromJson(jsonResponse);
        return _item;
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
            Text('Erro ao obter especialidade! ${response.reasonPhrase}')));
      }
    } else {
      return new EspecialidadeItem();
    }
  }

  Widget formularioWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          nomeController.text = snapshot.data.nome ;
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
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
                        hintText: 'Nome da especialidade',
                        labelText: 'Especialidade *'),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
      future: getEspecialidade(),
    );
  }
}
