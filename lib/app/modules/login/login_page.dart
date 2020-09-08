import 'package:dartZ/app/core/exceptions/login_failure.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  final loginCtrl = Modular.get<LoginController>();

  @override
  void didChangeDependencies() {
    reaction((fn) => loginCtrl.failure, (effect) {
      loginCtrl.failure.map((failure) {
        String message;
        if (failure is LoginNotFound) {
          message = 'Usuário não encontrado!';
        } else {
          message = 'Erro ao fazer login';
        }
        EdgeAlert.show(
          context,
          title: 'Erro',
          description: message,
          gravity: EdgeAlert.BOTTOM,
          icon: Icons.error,
          backgroundColor: Colors.redAccent,
          duration: EdgeAlert.LENGTH_SHORT,
        );
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: loginCtrl.phoneCtrl,
                decoration: InputDecoration(labelText: 'telefone'),
              ),
              TextFormField(
                controller: loginCtrl.passwordCtrl,
                decoration: InputDecoration(labelText: 'senha'),
              ),
              SizedBox(height: 20),
              Observer(builder: (_) {
                return RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.deepPurple,
                  onPressed: () {
                    loginCtrl.login();
                  },
                  child: loginCtrl.isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white),
                        ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
