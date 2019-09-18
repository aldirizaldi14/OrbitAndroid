import 'package:flutter/material.dart';
import 'logo.dart';
import 'menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                LogoMain(),
                Image.asset('assets/images/logo.jpg'),
                LoginField()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginField extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: (
              TextField(
                controller: usernameController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Username',
                    enabledBorder: OutlineInputBorder()
                ),
              )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: (
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder()
                ),
              )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            width: double.infinity,
            child: (
              FlatButton(
                color: Colors.blue,
                child: Text('LOGIN'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuMain()
                    )
                  );
                },
              )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Center(
              child: Image.asset('assets/images/flag-id.png'),
            )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Center(
              child: (
                Text('PT Panasonic Gobel Life Solutions')
              ),
            )
          ),
        ],
      ),
    );
  }
}
