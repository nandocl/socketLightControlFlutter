import 'package:flutter/material.dart';

import 'package:front/src/models/user.model.dart';

import 'package:front/src/services/http.service.dart' as httpService;
import 'package:front/src/services/socket.service.dart' as socketService;
import '../utils/tokenHandler.util.dart' as tokenUtil;
import '../widgets/progDialog.widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginForm = GlobalKey<FormState>();
  String _userLogin, _passwordLogin;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    tokenUtil.getTokenInStorage().then((token) {
      if (token == null) return;
      httpService.loginWithToken(token).then((UserItemModel user) async {
        if (user == null)
          return showAlert(
              title: 'Error!!!',
              content: 'La conexion con el servidor fue erronea');
        await socketService.socketConnect(token);
        Navigator.pushNamed(context, 'menu');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: login(),
    ));
  }

  Widget login() {
    return Container(
      margin: EdgeInsets.only(top: 60, left: 60, right: 60),
      child: Column(
        children: [
          Image.asset(
            'assets/imgs/logoLogin.png',
            height: 120,
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: _loginForm,
            child: Column(children: [
              TextFormField(
                autofocus: true,
                controller: userNameController,
                keyboardType: TextInputType.name,
                validator: (userField) {
                  if (userField.isEmpty) return 'Ingrese usuario';
                  return null;
                },
                onChanged: (user) => _userLogin = user,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (passwordField) {
                  if (passwordField.isEmpty) return 'Ingrese contrasena';
                  return null;
                },
                onChanged: (pass) => _passwordLogin = pass,
                decoration: InputDecoration(labelText: 'Contrasenia'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () async {
                        PgDialog().progressStart(context);
                        if (_loginForm.currentState.validate()) {
                          var res = await httpService.login(
                              userLogin: _userLogin,
                              passwordLogin: _passwordLogin);
                          if (res != null) {
                            PgDialog().progressStop(context);
                            socketService.socketConnect(res.token);
                            tokenUtil.saveTokenInStorage(res.token);
                            return Navigator.pushNamed(context, 'menu');
                          }
                          PgDialog().progressStop(context);
                          userNameController.clear();
                          passwordController.clear();
                          showAlert(
                              title: 'Error de login',
                              content: 'Error de login o de servidor.');
                        }

                        ///Mensaje llenar todos los campos
                        return print('Mal');
                      }),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void showAlert({String title, String content}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(title), Icon(Icons.info)]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text('Aceptar'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ])
                ],
              ),
            ));
  }
}
