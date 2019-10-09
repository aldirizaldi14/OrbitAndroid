import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/line_model.dart';
import 'package:unified_process/model/product_model.dart';
import 'package:unified_process/model/production_model.dart';
import 'package:unified_process/model/warehouse_model.dart';
import 'package:unified_process/helper/database_helper.dart';

String api_url = "http://192.168.1.6/api/";

Future<dynamic> apiLogin(String user, String passw) async {
  try{
    final response = await http.post(api_url + "login", body: {'username': user, 'password': passw });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }catch(e){
    return '';
  }
}

Future<dynamic> apiSyncWarehouse(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    /*
    final data = await db.rawQuery("SELECT * FROM warehouse WHERE warehouse_sync = 0");
    if(data != null){
      final response = await http.post(
        api_url + "warehouse/sync",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'data' : json.encode(data)}
      );
    }
    */
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
        if(data != null){
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
    } else {
      return '';
    }
  }catch(e){
    print(e);
    return '';
  }
}

Future<dynamic> apiSyncArea(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    /*
    final data = await db.rawQuery("SELECT * FROM warehouse WHERE warehouse_sync = 0");
    if(data != null){
      final response = await http.post(
        api_url + "warehouse/sync",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'data' : json.encode(data)}
      );
    }
    */
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
        if(data != null){
          dbHelper.update(datum.tableName, 'area_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
    } else {
      return '';
    }
  }catch(e){
    print(e);
    return '';
  }
}

Future<dynamic> apiSyncLine(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    /*
    final data = await db.rawQuery("SELECT * FROM warehouse WHERE warehouse_sync = 0");
    if(data != null){
      final response = await http.post(
        api_url + "warehouse/sync",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'data' : json.encode(data)}
      );
    }
    */
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
        if(data != null){
          dbHelper.update(datum.tableName, 'line_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
    } else {
      return '';
    }
  }catch(e){
    print(e);
    return '';
  }
}


Future<dynamic> apiSyncProduct(String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;

  try {
    /*
    final data = await db.rawQuery("SELECT * FROM warehouse WHERE warehouse_sync = 0");
    if(data != null){
      final response = await http.post(
        api_url + "warehouse/sync",
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer '+ token
        },
        body: {'data' : json.encode(data)}
      );
    }
    */
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
        if(data != null){
          dbHelper.update(datum.tableName, 'product_id', datum.toMap());
        }else{
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
    } else {
      return '';
    }
  }catch(e){
    print(e);
    return '';
  }
}