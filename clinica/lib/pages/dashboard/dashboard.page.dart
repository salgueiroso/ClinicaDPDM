import 'dart:convert';

import 'package:clinica/pages/consultas/marcar.edit.page.dart';
import 'package:clinica/pages/especialidades/especialidades.page.dart';
import 'package:clinica/pages/medicos/medicos.page.dart';
import 'package:clinica/pages/pacientes/pacientes.page.dart';
import 'package:clinica/requests/models/consulta.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:clinica/widgets/floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPage createState() => _DashboardPage();
}

class ConsultasRetData {
  final List<ConsultaItem> consultas;

  ConsultasRetData({this.consultas});
}

class _DashboardPage extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Clinica - Dashboard (Consultas)'),
        ),
        body: listaPrincipalWidget(),
        floatingActionButton: FloatingButtons(
          actions: [
            FloatButtonItem(
                icon: Icon(Icons.group),
                label: 'Especialidade',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EspecialidadesPage()))),
            FloatButtonItem(
                icon: Icon(Icons.contacts),
                label: 'Medico',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MedicosPage()))),
            FloatButtonItem(
                icon: Icon(Icons.calendar_today),
                label: 'Marcar Consulta',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MarcacaoConsultaEditPage()))),
            FloatButtonItem(
                icon: Icon(Icons.accessibility),
                label: 'Paciente',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PacientesPage()))),
          ],
        ));
  }

  Future<List<ConsultaItem>> getProximasConsultas() async {
    var response = await get(URL_CONSULTAS_LISTAR);
    if (response.statusCode == 200) {

      var jsonResponse = json.decode(response.body);

      var _items = (jsonResponse as List)
          .map((a) => new ConsultaItem.fromJson(a))
          .toList();

      return _items;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text('Erro ao carregar consultas! ${response.reasonPhrase}')));
      return null;
    }
  }

  Future<ConsultasRetData> fetchData() async {
    var consultas = await getProximasConsultas();

    return ConsultasRetData(consultas: consultas);
  }

  Widget listaPrincipalWidget() {
    return FutureBuilder<ConsultasRetData>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.consultas.length,
            itemBuilder: (context, index) {
              final item = snapshot.data.consultas[index];

              return Card(
                child: ListTile(
                  //onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>MarcacaoConsultaEditPage(id: item,))),
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
      future: fetchData(),
    );
  }
}
