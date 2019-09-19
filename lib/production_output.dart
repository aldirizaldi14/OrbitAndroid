import 'package:flutter/material.dart';
import 'model/production.dart';

class ProductionOutputClass extends StatelessWidget {
  final String title = 'Production Output';
  final productionData = [
    Production(1, '09190001', '2019-09-19 07:00:00', 10),
    Production(2, '09190002', '2019-09-19 08:00:00', 5),
    Production(3, '09190003', '2019-09-19 09:00:00', 7),
    Production(4, '09190004', '2019-09-19 10:00:00', 9),
    Production(5, '09190005', '2019-09-19 11:00:00', 8),
    Production(6, '09190006', '2019-09-19 12:00:00', 4),
    Production(7, '09190007', '2019-09-19 13:00:00', 10),
    Production(8, '09190008', '2019-09-19 14:00:00', 7),
    Production(9, '09190009', '2019-09-19 15:00:00', 4),
    Production(10, '09190010', '2019-09-19 16:00:00', 9),
    Production(11, '09190011', '2019-09-19 17:00:00', 8),
    Production(12, '09190012', '2019-09-19 18:00:00', 6),
    Production(13, '09190013', '2019-09-19 19:00:00', 7),
    Production(14, '09190014', '2019-09-19 20:00:00', 6),
    Production(15, '09190015', '2019-09-19 21:00:00', 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/production_output_add'),
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
                    Text(p.code, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                    Text(p.time, style: TextStyle( fontSize: 12),),
                  ],
                ),
                Text(p.qty.toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
              ],
            )
          );
        },
        itemCount: productionData.length,
      )
    );
  }
}