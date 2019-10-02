import 'package:flutter/material.dart';
import 'logo.dart';

class LoginClass extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Container loginField(BuildContext context){
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
                  Navigator.pushNamed(context, '/menu');
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
                  Text('PT. Panasonic Gobel Life Solutions Manufacturing Indonesia', style: TextStyle(fontSize: 11),)
              ),
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                LogoMain(),
                Image.asset('assets/images/logo.jpg'),
                loginField(context)
              ],
            ),
          ),
        )
      ),
    );
  }
}