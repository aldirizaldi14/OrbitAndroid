import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'logo.dart';
import 'api_services.dart';

class LoginClass extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginClass> {
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
                decoration: InputDecoration(
                    labelText: 'Username',
                    enabledBorder: OutlineInputBorder(),
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
                onPressed: () async {
                  if(usernameController.text.isEmpty || passwordController.text.isEmpty){
                    Toast.show("Please complete all field.", context);
                  }else {
                    final response = await apiLastUpdate(usernameController.text, passwordController.text);
                    print(response);
                    Map<String, dynamic> res = json.decode(response);
                    if(res['success']){
                      Map<String, dynamic> user = res['message'];
                      SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
                      _sharedPreferences.setInt('USER_ID', user['user_id'] is int ? user['user_id'] : int.parse(user['user_id']));
                      _sharedPreferences.setInt('USER_GROUP_ID', user['user_group_id'] is int ? user['user_group_id'] : int.parse(user['user_group_id']));
                      _sharedPreferences.setString('USER_USERNAME', user['user_username']);
                      _sharedPreferences.setString('USER_FULLNAME', user['user_fullname']);
                      _sharedPreferences.setString('USER_TOKEN', user['api_token']);
                      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                    }else{
                      Toast.show(res['message'], context);
                    }
                  }
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