import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  final String title = 'About';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/logo.png', width: 150, height: 150,),
                Center(child: Text("Orbit Application", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),),
                Center(child: Text("Version : 1.2.1"),),
                Container(height: 20,),
                Center(child: Text("Aplication to record production and warehouse process in PT. Panasonic Gobel Life Solutions Manufacturing Indonesia.", textAlign: TextAlign.center,),),
                Divider(),
                Container(height: 20,),
                Center(child: Text("Have some issue ?", textAlign: TextAlign.center,),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.message),
                      onPressed: () => _sendWa(),
                    ),
                    FlatButton(
                      child: Icon(Icons.call),
                      onPressed: () => _sendCall(),
                    ),
                    FlatButton(
                      child: Icon(Icons.email),
                      onPressed: () => _sendMail(),
                    ),
                  ],
                ),
                Divider(),
                Container(height: 20,),
                Center(child: Text("Orbit \u00a9 2020", textAlign: TextAlign.center,),),
                Center(child: Text("PT. Panasonic Gobel Life Solutions Manufacturing Indonesia", textAlign: TextAlign.center,),),
              ]
            ),
          ),
        )
    );
  }

  void _sendWa() async {
    String phone = '628127992271';
    String url = 'whatsapp://send?phone=$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
      throw 'Could not launch $url';
    }
  }
  void _sendMail() async {
    String url = 'mailto:muhammad.syarifuddin@id.panasonic.com?subject=Unified%20Process';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _sendCall() async {
    String url = 'tel:08127992271';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}