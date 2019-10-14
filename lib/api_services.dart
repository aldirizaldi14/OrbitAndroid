import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/line_model.dart';
import 'package:unified_process/model/product_model.dart';
import 'package:unified_process/model/production_model.dart';
import 'package:unified_process/model/receipt_model.dart';
import 'package:unified_process/model/receiptdet_model.dart';
import 'package:unified_process/model/response.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'package:unified_process/model/warehouse_model.dart';
import 'package:unified_process/helper/database_helper.dart';

String api_url = "http://192.168.1.9/api/";

Future<dynamic> apiLogin(String user, String passw) async {
  try{
    final response = await http.post(api_url + "login", body: {'username': user, 'password': passw });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return '';
  }
}

Future<bool> apiSyncWarehouse(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
      api_url + "warehouse/data",
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer '+ token
      },
      body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        WarehouseModel wh = WarehouseModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT warehouse_id FROM warehouse WHERE warehouse_id = ? ", [wh.warehouse_id]);
        if(data.length > 0){
          dbHelper.update(wh.tableName, 'warehouse_id', wh.toMap());
        }else{
          dbHelper.insert(wh.tableName, wh.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncArea(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
        api_url + "area/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        AreaModel datum = AreaModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT area_id FROM area WHERE area_id = ? ", [datum.area_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'area_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM area ORDER BY area_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncLine(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
        api_url + "line/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        LineModel datum = LineModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT line_id FROM line WHERE line_id = ? ", [datum.line_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'line_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM line ORDER BY line_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncProduct(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
        api_url + "product/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        ProductModel datum = ProductModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT product_id FROM product WHERE product_id = ? ", [datum.product_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'product_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM product ORDER BY product_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncProduction(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final data = await db.rawQuery("SELECT * FROM production WHERE production_sync = 0");
    if(data.length > 0){
      for(int i=0; i<data.length; i++){
        ProductionModel datum = ProductionModel.fromDb(data[i]);
        final resPost = await http.post(
            api_url + "production/sync",
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer '+ token
            },
            body: {'data': json.encode(datum.toMap()) }
        );
        if(resPost.statusCode == 200 && json.decode(resPost.body)['success'] == true){
          dbHelper.delete('production', 'production_id', datum.production_id);
        }else{
          throw(resPost.body);
        }
      }
    }

    final response = await http.post(
        api_url + "production/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        ProductionModel datum = ProductionModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT production_id FROM production WHERE production_id = ? ", [datum.production_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'production_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM production ORDER BY production_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncTransfer(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final data = await db.rawQuery("SELECT * FROM transfer WHERE transfer_sync = 0");
    if(data.length > 0){
      for(int i=0; i<data.length; i++){
        TransferModel datum = TransferModel.fromDb(data[i]);
        final detail = await db.rawQuery("SELECT * FROM transferdet WHERE transferdet_transfer_id = ?", [datum.transfer_id]);
        final resPost = await http.post(
            api_url + "transfer/sync",
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer '+ token
            },
            body: {'data': json.encode(datum.toMap()), 'detail': json.encode(detail) }
        );
        if(resPost.statusCode == 200 && json.decode(resPost.body)['success'] == true){
          dbHelper.delete('transfer', 'transfer_id', datum.transfer_id);
          dbHelper.delete('transferdet', 'transferdet_transfer_id', datum.transfer_id);
        }else{
          throw(resPost.body);
        }
      }
    }

    final response = await http.post(
        api_url + "transfer/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        TransferModel datum = TransferModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT transfer_id FROM transfer WHERE transfer_id = ? ", [datum.transfer_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'transfer_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM transfer ORDER BY transfer_id ASC");
      print(data);
       */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncTransferdet(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
        api_url + "transfer/detail",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        TransferdetModel datum = TransferdetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT transferdet_id FROM transferdet WHERE transferdet_id = ? ", [datum.transferdet_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'transferdet_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM transferdet ORDER BY transferdet_id ASC");
      print(data);
      */
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncReceipt(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final data = await db.rawQuery("SELECT * FROM receipt WHERE receipt_sync = 0 OR receipt_sync IS NULL");
    if(data.length > 0){
      for(int i=0; i<data.length; i++){
        ReceiptModel datum = ReceiptModel.fromDb(data[i]);
        final detail = await db.rawQuery("SELECT * FROM receiptdet WHERE receiptdet_receipt_id = ?", [datum.receipt_id]);
        print(detail);
        final resPost = await http.post(
            api_url + "receipt/sync",
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer '+ token
            },
            body: {'data': json.encode(datum.toMap()), 'detail': json.encode(detail) }
        );
        if(resPost.statusCode == 200 && json.decode(resPost.body)['success'] == true){
          dbHelper.delete('receipt', 'receipt_id', datum.receipt_id);
          dbHelper.delete('receiptdet', 'receiptdet_receipt_id', datum.receipt_id);
        }else{
          throw(resPost.body);
        }
      }
    }

    final response = await http.post(
        api_url + "receipt/data",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for(int i=0; i<res.length; i++){
        ReceiptModel datum = ReceiptModel.fromDb(res[i]);
        final data = await db.rawQuery("SELECT receipt_id FROM receipt WHERE receipt_id = ? ", [datum.receipt_id]);
        if(data.length > 0){
          dbHelper.update(datum.tableName, 'receipt_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug */
      final data = await db.rawQuery("SELECT * FROM receipt ORDER BY receipt_id ASC");
      print(data);
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> apiSyncReceiptdet(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    final response = await http.post(
        api_url + "receipt/detail",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'last_update': last_update }
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ReceiptdetModel datum = ReceiptdetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT receiptdet_id FROM receiptdet WHERE receiptdet_id = ? ", [datum.receiptdet_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'receiptdet_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      */
      final data = await db.rawQuery("SELECT * FROM receiptdet ORDER BY receiptdet_id ASC");
      print(data);
      return true;
    } else {
      throw(response.body);
    }
  }catch(e){
    print(e);
    return false;
  }
}