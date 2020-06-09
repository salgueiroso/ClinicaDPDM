import 'dart:convert';

import 'file:///C:/Projetos/Unit/clinica/clinica/lib/pages/especialidades/especialidades.edit.page.dart';
import 'package:clinica/pages/medicos/medicos.edit.page.dart';
import 'package:clinica/requests/models/medico.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:clinica/widgets/floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MedicosPage extends StatefulWidget {
  MedicosPage({Key key}) : super(key: key);

  @override
  _MedicosPage createState() => _MedicosPage();
}

class _MedicosPage extends State<MedicosPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Médicos"),
        ),
        body: ListaPrincipalWidget(),
        floatingActionButton: FloatingButtons(
          actions: [
            FloatButtonItem(
                icon: Icon(Icons.add),
                label: 'Novo',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => MedicosEditPage(
                              id: 0,
                            ))).then((value) => this.setState(() {}))),
          ],
        ));
  }

  Future getMedicos() async {
    var response = await get(URL_MEDICOS_LISTAR);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
      jsonResponse.map((a) => new MedicoItem.fromJson(a)).toList();
      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
          Text('Erro ao obter as especialidades! ${response.reasonPhrase}')));
    }
  }


  Future deleteMedico(int id) async {
    var response = await delete('$URL_MEDICOS_LISTAR/$id');
    if (response.statusCode == 200) {

    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
          content:
          Text('Erro ao remover a médico! (${response.reasonPhrase})')));
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
                  deleteMedico(id).then((value) => this.setState(() {}));
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

  Widget ListaPrincipalWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];

              return Card(
                child: ListTile(
                  onLongPress: ()=> showDialogDeleteAction(item.Id) ,
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MedicosEditPage(
                        id: item.Id,
                      ))),
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
      future: getMedicos(),
    );
  }
}




