import 'package:flutter/material.dart';
import 'model/production.dart';

class WarehouseReceipt extends StatelessWidget {
  final String title = 'Warehouse Receipt';
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
          onPressed: () => Navigator.pushNamed(context, '/warehouse_receipt_add'),
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
                    Text(p.production_qty.toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                )
            );
          },
          itemCount: productionData.length,
        )
    );
  }
}