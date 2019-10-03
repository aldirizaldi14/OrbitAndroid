import 'package:flutter/material.dart';
import 'model/production.dart';

class ProductionTransferAdd extends StatelessWidget {
  final String title = 'Production Transfer Add';
  final productionData = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Input Quantity'),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new TextField(
                          autofocus: true,
                          decoration: new InputDecoration(labelText: ''),
                          onChanged: (value) {

                          },
                        )
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Submit'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          },
          itemBuilder: (context, index) {
            Production p = productionData[index];
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(p.production_code, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                        Text(p.production_time, style: TextStyle( fontSize: 12),),
                      ],
                    ),
                    Text(p.production_product_id.toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                )
            );
          },
          itemCount: productionData.length,
        )
    );
  }
}