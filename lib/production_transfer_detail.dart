import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';
import 'model/transfer_model.dart';

class ProductionTransferDetailClass extends StatefulWidget {
  ProductionTransferDetailClass({ Key key}) : super (key: key);
  final String title = 'Transfer Detail';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferDetailState createState() => ProductionTransferDetailState();
}

class ProductionTransferDetailState extends State<ProductionTransferDetailClass> {
  List listData = [];
  void fetchData(id) async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT transferdet_id, transferdet_transfer_id, transferdet_qty, product_id, product_code "
        "FROM transferdet "
        "JOIN product ON product.product_id = transferdet.transferdet_product_id "
        "WHERE transferdet_transfer_id = ?", [id]
    );
    print(data);
    setState(() {
      listData = data;
    });
  }

  void saveData(id) async{
    TransferModel transferModel = TransferModel.instance;
    transferModel.transfer_id = id;
    transferModel.transfer_updated_at = new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateTime.now());
    int transfer_id = await widget.databaseHelper.update(transferModel.tableName, 'transfer_id', transferModel.toMap());
    if(transfer_id > 0){
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    fetchData(args[0]);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: QrImage(
                  data: listData.toString(),
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  saveData(args[0]);
                },
                child: Text('Already Sent', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
    );
  }
}