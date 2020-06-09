import 'dart:convert';

import 'package:clinica/pages/pacientes/pacientes.edit.page.dart';
import 'package:clinica/requests/models/paciente.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:clinica/widgets/floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PacientesPage extends StatefulWidget {
  PacientesPage({Key key}) : super(key: key);

  @override
  _PacientesPage createState() => _PacientesPage();
}

class _PacientesPage extends State<PacientesPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Pacientes"),
        ),
        body: listaPrincipalWidget(),
        floatingActionButton: FloatingButtons(
          actions: [
            FloatButtonItem(
                icon: Icon(Icons.add),
                label: 'Novo',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PacientesEditPage(
                              id: 0,
                            ))).then((value) => this.setState(() {}))),
          ],
        ));
  }

  Future getPacientes() async {
    var response = await get(URL_PACIENTES_LISTAR);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
      jsonResponse.map((a) => new PacienteItem.fromJson(a)).toList();
      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
          Text('Erro ao obter os pacientes! ${response.reasonPhrase}')));
    }
  }


  Future deletePaciente(int id) async {
    var response = await delete('$URL_PACIENTES_LISTAR/$id');
    if (response.statusCode == 200) {

    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
          content:
          Text('Erro ao remover paciente! (${response.reasonPhrase})')));
    }
  }

  void showDialogDeleteAction(int id){
    showDialog(
        context: context,
      builder: (BuildContext context){
          return AlertDialog(
            title: Text('Confirmação'),
            content: Text('Deseja remover este item?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Excluir'),
                onPressed: (){
                  deletePaciente(id).then((value) => this.setState(() {}));
                  Navigator
                      .of(context)
                      .pop();
                },
              ),
              FlatButton(
                child: Text('Cancelar'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
      }
    );
  }

  Widget listaPrincipalWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];

              return Card(
                child: ListTile(
                  onLongPress: ()=> showDialogDeleteAction(item.id) ,
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PacientesEditPage(
                        id: item.id,
                      ))).then((value) { setState(() {});}),
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                  isThreeLine: item.isThreeLines(),
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
      future: getPacientes(),
    );
  }
}




