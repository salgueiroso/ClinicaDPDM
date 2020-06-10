import 'dart:convert';

import 'package:clinica/pages/dashboard/dashboard.page.dart';
import 'package:clinica/pages/pacientes/pacientes.edit.page.dart';
import 'package:clinica/requests/models/login.model.dart';
import 'package:clinica/requests/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  final loginController = new TextEditingController();
  final senhaController = new TextEditingController();

  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Autenticação'),
        ),
        body: Stack(
          children: [formularioWidget(), showCircularProgress()],
        ));
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget formularioWidget() {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(children: [
              Hero(
                tag: 'hero',
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 58.0,
                      child: Icon(
                        Icons.local_hospital,
                        size: 200,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                child: new TextFormField(
                  controller: loginController,
                  maxLines: 1,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: 'Email',
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value.isEmpty ? 'Email não pode ser vazia' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new TextFormField(
                  controller: senhaController,
                  maxLines: 1,
                  obscureText: true,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: 'Senha',
                      icon: new Icon(
                        Icons.lock,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value.isEmpty ? 'Senha não pode ser vazia' : null,
                ),
              ),
              FlatButton(
                child: new Text('Criar conta',
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w300)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PacientesEditPage())),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Login',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: sendLogin,
                    ),
                  )),
            ])));
  }

  void sendLogin() async {
    if (!_formKey.currentState.validate()) return;

    setState(() {
      _isLoading = true;
    });

    //String userId = "";
    try {
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var body = json.encode(
          LoginItem(login: loginController.text, senha: senhaController.text));

      var response = await post(URL_LOGIN, headers: headers, body: body);

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        var success = jsonResult as bool;

        if (!success) {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text('Usuário/Senha inválido.')));
          return;
        }

        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Logado!')));
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
                'Erro ao salvar especialidade! ${response.reasonPhrase}')));
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Erro ao salvar especialidade! $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
