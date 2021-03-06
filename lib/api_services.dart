import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/allocation_model.dart';
import 'package:unified_process/model/allocationdet_model.dart';
import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/area_product_qty_model.dart';
import 'package:unified_process/model/delivery_model.dart';
import 'package:unified_process/model/delivery309112_model.dart';
import 'package:unified_process/model/deliverydet_model.dart';
import 'package:unified_process/model/line_model.dart';
import 'package:unified_process/model/product_model.dart';
import 'package:unified_process/model/production_model.dart';
import 'package:unified_process/model/receipt_model.dart';
import 'package:unified_process/model/receiptdet_model.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'package:unified_process/model/warehouse_model.dart';
import 'package:unified_process/helper/database_helper.dart';

//String api_url = "http://192.168.1.19/orbit/public/api/";
String api_url = "http://137.40.52.103/up/public/api/";
Future<dynamic> apiLogin(String user, String passw) async {
  try {
    final response = await http
        .post(api_url + "login", body: {'username': user, 'password': passw});
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> apiChangePassword(String token, String pass) async {
  try {
    final response = await http.post(api_url + "changepass", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'password': pass
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncWarehouse(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('warehouse');
  try {
    final response = await http.post(api_url + "warehouse/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        WarehouseModel wh = WarehouseModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT warehouse_id FROM warehouse WHERE warehouse_id = ? ",
            [wh.warehouse_id]);
        if (data.length > 0) {
          dbHelper.update(wh.tableName, 'warehouse_id', wh.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncArea(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('area');
  try {
    final response = await http.post(api_url + "area/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        AreaModel datum = AreaModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT area_id FROM area WHERE area_id = ? ", [datum.area_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'area_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncLine(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('line');
  try {
    final response = await http.post(api_url + "line/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        LineModel datum = LineModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT line_id FROM line WHERE line_id = ? ", [datum.line_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'line_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncProduct(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('product');
  try {
    final response = await http.post(api_url + "product/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ProductModel datum = ProductModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT product_id FROM product WHERE product_id = ? ",
            [datum.product_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'product_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncProduction(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('production');
  try {
    await db.rawQuery(
        "DELETE FROM production WHERE production_sync = 1 AND date(production_time) <= date('now','-2 day')");
    final data =
        await db.rawQuery("SELECT * FROM production WHERE production_sync = 0");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        ProductionModel datum = ProductionModel.fromDb(data[i]);
        final resPost = await http.post(api_url + "production/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap())
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('production', 'production_id', datum.production_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "production/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ProductionModel datum = ProductionModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT production_id FROM production WHERE production_id = ? ",
            [datum.production_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'production_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncTransfer(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('transfer');
  try {
    await db.rawQuery(
        "DELETE FROM transfer WHERE transfer_sync = 1 AND date(transfer_time) <= date('now','-2 day')");
    final data =
        await db.rawQuery("SELECT * FROM transfer WHERE transfer_sync = 0");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        TransferModel datum = TransferModel.fromDb(data[i]);
        final detail = await db.rawQuery(
            "SELECT * FROM transferdet WHERE transferdet_transfer_id = ?",
            [datum.transfer_id]);
        final resPost = await http.post(api_url + "transfer/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap()),
          'detail': json.encode(detail)
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('transfer', 'transfer_id', datum.transfer_id);
          dbHelper.delete(
              'transferdet', 'transferdet_transfer_id', datum.transfer_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "transfer/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        TransferModel datum = TransferModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT transfer_id FROM transfer WHERE transfer_id = ? ",
            [datum.transfer_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'transfer_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncTransferdet(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('transferdet');
  try {
    await db.rawQuery(
        "DELETE FROM transferdet WHERE date(transferdet_created_at) <= date('now','-2 day')");
    final response = await http.post(api_url + "transfer/detail", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        TransferdetModel datum = TransferdetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT transferdet_id FROM transferdet WHERE transferdet_id = ? ",
            [datum.transferdet_id]);
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncReceipt(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('receipt');
  try {
    await db.rawQuery(
        "DELETE FROM receipt WHERE receipt_sync = 1 AND date(receipt_time) <= date('now','-2 day')");
    final data = await db.rawQuery(
        "SELECT * FROM receipt WHERE receipt_sync = 0 OR receipt_sync IS NULL");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        ReceiptModel datum = ReceiptModel.fromDb(data[i]);
        final detail = await db.rawQuery(
            "SELECT * FROM receiptdet WHERE receiptdet_receipt_id = ?",
            [datum.receipt_id]);
        final resPost = await http.post(api_url + "receipt/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap()),
          'detail': json.encode(detail)
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('receipt', 'receipt_id', datum.receipt_id);
          dbHelper.delete(
              'receiptdet', 'receiptdet_receipt_id', datum.receipt_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "receipt/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ReceiptModel datum = ReceiptModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT receipt_id FROM receipt WHERE receipt_id = ? ",
            [datum.receipt_id]);
        await db.rawQuery(
            "UPDATE transfer SET transfer_sent_at = ? WHERE transfer_id = ? ",
            [datum.receipt_time, datum.receipt_transfer_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'receipt_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM receipt ORDER BY receipt_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncReceiptdet(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('receiptdet');
  try {
    await db.rawQuery(
        "DELETE FROM receiptdet WHERE date(receiptdet_created_at) <= date('now','-2 day')");
    final response = await http.post(api_url + "receipt/detail", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ReceiptdetModel datum = ReceiptdetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT receiptdet_id FROM receiptdet WHERE receiptdet_id = ? ",
            [datum.receiptdet_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'receiptdet_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM receiptdet ORDER BY receiptdet_id ASC");
      print(data);
      */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncAllocation(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('allocation');
  try {
    await db.rawQuery(
        "DELETE FROM allocation WHERE allocation_sync = 1 AND date(allocation_time) <= date('now','-2 day')");
    final data =
        await db.rawQuery("SELECT * FROM allocation WHERE allocation_sync = 0");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        AllocationModel datum = AllocationModel.fromDb(data[i]);
        final detail = await db.rawQuery(
            "SELECT * FROM allocationdet WHERE allocationdet_allocation_id = ?",
            [datum.allocation_id]);
        final resPost = await http.post(api_url + "allocation/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap()),
          'detail': json.encode(detail)
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('allocation', 'allocation_id', datum.allocation_id);
          dbHelper.delete('allocationdet', 'allocationdet_allocation_id',
              datum.allocation_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "allocation/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        AllocationModel datum = AllocationModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT allocation_id FROM allocation WHERE allocation_id = ? ",
            [datum.allocation_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'allocation_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM allocation ORDER BY allocation_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncAllocationdet(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('allocationdet');
  try {
    await db.rawQuery(
        "DELETE FROM allocationdet WHERE date(allocationdet_created_at) <= date('now','-2 day')");
    final response = await http.post(api_url + "allocation/detail", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        AllocationdetModel datum = AllocationdetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT allocationdet_id FROM allocationdet WHERE allocationdet_id = ? ",
            [datum.allocationdet_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'allocationdet_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM allocationdet ORDER BY allocationdet_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

/*Future<bool> apiSyncDelivery(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('delivery');
  try {
    await db.rawQuery(
        "DELETE FROM delivery WHERE delivery_sync = 1 AND date(delivery_time) <= date('now','-2 day')");
    final data =
        await db.rawQuery("SELECT * FROM delivery WHERE delivery_sync = 0");
    print(data);
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        DeliveryModel datum = DeliveryModel.fromDb(data[i]);
        final detail = await db.rawQuery(
            "SELECT * FROM deliverydet WHERE deliverydet_delivery_id = ?",
            [datum.delivery_id]);
        final resPost = await http.post(api_url + "delivery/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap()),
          'detail': json.encode(detail)
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('delivery', 'delivery_id', datum.delivery_id);
          dbHelper.delete('deliverydet', 'deliverydet__id', datum.delivery_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "delivery/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      print(response.body);
      for (int i = 0; i < res.length; i++) {
        DeliveryModel datum = DeliveryModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT delivery_id FROM delivery WHERE delivery_id = ? ",
            [datum.delivery_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'delivery_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM delivery ORDER BY delivery_id ASC");
      print(data);
      */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}*/

Future<bool> apiSyncDeliverydet(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('deliverydet');
  try {
    await db.rawQuery(
        "DELETE FROM deliverydet WHERE date(deliverydet_created_at) <= date('now','-2 day')");
    final response = await http.post(api_url + "delivery/detail", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        DeliverydetModel datum = DeliverydetModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT deliverydet_id FROM deliverydet WHERE deliverydet_id = ? ",
            [datum.deliverydet_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'deliverydet_id', datum.toMap());
        } else {
          dbHelper.insert(datum.tableName, datum.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM deliverydet ORDER BY deliverydet_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncQty(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('qty');
  try {
    final response = await http.post(api_url + "qty/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      await db.rawQuery("DELETE FROM area_product_qty");
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        AreaProductQtyModel datum = AreaProductQtyModel.fromDb(res[i]);
        dbHelper.insert(datum.tableName, datum.toMap());
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM area_product_qty ORDER BY area_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncDelivery(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('delivery');
  try {
    final response = await http.post(api_url + "delivery/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        Delivery309112Model sj = Delivery309112Model.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT delivery_id FROM sj_number WHERE delivery_id = ? ",
            [sj.delivery_id]);
        if (data.length > 0) {
          dbHelper.update(sj.tableName, 'delivery_id', sj.toMap());
        } else {
          dbHelper.insert(sj.tableName, sj.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncSuratjalan(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('suratjalan');
  try {
    //send data to server
    final data = await db.rawQuery("SELECT * FROM sj_number WHERE delivery_sync = 0");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        Delivery309112Model datum = Delivery309112Model.fromDb(data[i]);
        final resPost = await http.post(api_url + "surat_jalan/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap())
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
            dbHelper.delete('sj_number', 'delivery_id', datum.delivery_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "delivery/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        Delivery309112Model sj = Delivery309112Model.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT delivery_id FROM sj_number WHERE delivery_id = ? ",
            [sj.delivery_id]);
        if (data.length > 0) {
          dbHelper.update(sj.tableName, 'delivery_id', sj.toMap());
        } else {
          dbHelper.insert(sj.tableName, sj.toMap());
        }
      }
      /*
       * Uncomment for debug
      final data = await db.rawQuery("SELECT * FROM warehouse ORDER BY warehouse_id ASC");
      print(data);
       */
      return true;
    } else {
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> apiSyncProduction2(
    String token, String last_update, DatabaseHelper dbHelper) async {
  Database db = await dbHelper.database;
  print('production');
  try {
    await db.rawQuery(
        "DELETE FROM production WHERE production_sync = 1 AND date(production_time) <= date('now','-2 day')");
    final data =
    await db.rawQuery("SELECT * FROM production WHERE production_sync = 0");
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        ProductionModel datum = ProductionModel.fromDb(data[i]);
        final resPost = await http.post(api_url + "production/sync", headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        }, body: {
          'data': json.encode(datum.toMap())
        });
        if (resPost.statusCode == 200 &&
            json.decode(resPost.body)['success'] == true) {
          dbHelper.delete('production', 'production_id', datum.production_id);
        } else {
          throw (resPost.body);
        }
      }
    }

    final response = await http.post(api_url + "production/data", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    }, body: {
      'last_update': last_update
    });
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      for (int i = 0; i < res.length; i++) {
        ProductionModel datum = ProductionModel.fromDb(res[i]);
        final data = await db.rawQuery(
            "SELECT production_id FROM production WHERE production_id = ? ",
            [datum.production_id]);
        if (data.length > 0) {
          dbHelper.update(datum.tableName, 'production_id', datum.toMap());
        } else {
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
      throw (response.body);
    }
  } catch (e) {
    print(e);
    return false;
  }
}