import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:unified_process/delivery309112.dart';
import 'package:unified_process/deliveryloading.dart';

import 'deliverypicker.dart';

void main() {
  runApp(MaterialApp(
    home: MenuDeliveryClass(),
    debugShowCheckedModeBanner: false,
  ));
}

class MenuDeliveryClass extends StatefulWidget {
  @override
  MenuDeliveryState createState() => MenuDeliveryState();
}

class MenuDeliveryState extends State<MenuDeliveryClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Delivery"),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("Delivery Prepareration"),
              leading: Icon(MaterialCommunityIcons.account_check_outline),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeliveryPickerClass()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Delivery Loading"),
              leading: Icon(MaterialCommunityIcons.truck_delivery),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeliveryScanAddClass()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
