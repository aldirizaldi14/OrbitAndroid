import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WarehouseReceiptAdd extends StatefulWidget {
  WarehouseReceiptAdd({ Key key}) : super (key: key);
  final String title = 'Warehouse Receipt Add';

  @override
  WarehouseReceiptAddState createState() => WarehouseReceiptAddState();
}

class WarehouseReceiptAddState extends State<WarehouseReceiptAdd> {
  String productCode = '';
  String description = '';
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
      description = '19-09-2019 07:00:00';
    });
  }

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
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Icon(FontAwesomeIcons.barcode, color: Colors.white,),
                  onPressed: (){
                    setState(() {
                      productCode = 'TRF00001';
                      description = '19-09-2019 07:00:00';
                    });
                  },
                ),
              ),
              Text(productCode, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text(description, style: TextStyle(fontSize: 12),),
              Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
                  children: [
                    TableRow(
                        children: [
                          Text('#'),
                          Text('Warehouse'),
                          Text('Pallet'),
                          Text('Qty'),
                        ]
                    ),
                  ]
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
                    children: [
                      TableRow(
                          children: [
                            Text('1'),
                            Text('A'),
                            Text('2'),
                            Text('10'),
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('1'),
                            Text('A'),
                            Text('2'),
                            Text('10'),
                          ]
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}