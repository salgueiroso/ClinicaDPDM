import 'dart:convert';

import 'package:clinica/pages/especialidades/especialidades.edit.page.dart';
import 'package:clinica/requests/models/especialidade.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:clinica/widgets/floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EspecialidadesPage extends StatefulWidget {
  EspecialidadesPage({Key key}) : super(key: key);

  @override
  _EspecialidadesPage createState() => _EspecialidadesPage();
}

class _EspecialidadesPage extends State<EspecialidadesPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Especialidades"),
        ),
        body: ProcumasConsultasWidget(),
        floatingActionButton: FloatingButtons(
          actions: [
            FloatButtonItem(
                icon: Icon(Icons.add),
                label: 'Nova',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EspecialidadesEditPage(
                              id: 0,
                            ))).then((value) => this.setState(() {}))),
          ],
        ));
  }

  Future getEspecialidades() async {
    var response = await get(URL_ESPECIALIDADES_LISTAR);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
      jsonResponse.map((a) => new EspecialidadeItem.fromJson(a)).toList();
      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
          Text('Erro ao obter as especialidades! ${response.reasonPhrase}')));
    }
  }


  Future deleteEspecialidade(int id) async {
    var response = await delete('$URL_ESPECIALIDADES_LISTAR/$id');
    if (response.statusCode == 200) {

    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
          content:
          Text('Erro ao remover a especialidade! (${response.reasonPhrase})')));
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
                  deleteEspecialidade(id).then((value) => this.setState(() {}));
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

  Widget ProcumasConsultasWidget() {
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
                      builder: (context) => EspecialidadesEditPage(
                        id: item.Id,
                      ))),
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                  isThreeLine: item.isThreeLines(),
                ),
              );
            },
          );
        } else if (snapshot.hasData) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
      future: getEspecialidades(),
    );
  }
}