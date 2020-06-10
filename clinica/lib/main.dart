import 'package:clinica/pages/consultas/marcar.edit.page.dart';
import 'package:clinica/pages/login/login.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ClinicaApp());
}

class ClinicaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MarcacaoConsultaEditPage(),
      //home: LoginPage(),
    );
  }
}
