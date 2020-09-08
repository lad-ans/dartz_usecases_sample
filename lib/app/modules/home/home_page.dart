import 'package:dartZ/app/core/consts/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (!value.containsKey(ACCESS_TOKEN)) {
        Modular.to.pushNamedAndRemoveUntil('/login', (_) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.deepPurple,
          onPressed: () async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.clear();
            Modular.to.pushNamedAndRemoveUntil('/login', (_) => false);
          },
          child: Text(
            'Sair',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
