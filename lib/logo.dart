import 'package:flutter/material.dart';
void main() => runApp(LogoMain());

class LogoMain extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset('assets/images/panasonic.png'),
          Image.asset('assets/images/gobel.png'),
        ],
      ),
    );
  }
}