import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:unified_process/api_services.dart';

class Setting extends StatefulWidget {
  Setting({ Key key}) : super (key: key);
  final String title = 'Change Password';

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  TextEditingController newController = TextEditingController();
  TextEditingController confController = TextEditingController();
  SharedPreferences _sharedPreferences;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: new InputDecoration(labelText: 'New Password'),
                controller: newController,
              ),TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: new InputDecoration(labelText: 'Confirm Password'),
                controller: confController,
              ),
              FlatButton(
                color: Colors.lightBlue,
                child: Text('Save'),
                onPressed: () {
                  save();
                },
              )
            ]
          ),
        )
    );
  }
  
  void save() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if(newController.text == confController.text){
      bool saved = await apiChangePassword(_sharedPreferences.getString('USER_TOKEN'), newController.text);
      if(saved){
        Toast.show('Success', context);
        Navigator.pop(context);
      }else{
        Toast.show('Unable to save data at this moment', context);
      }
    }else{
      Toast.show('Password not match', context);
    }
  }
}