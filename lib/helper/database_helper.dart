import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "unified_process.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE product("
        "product_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "product_code_alt TEXT,"
        "product_code TEXT,"
        "product_description TEXT,"
        "product_server_id INTEGER,"
        "product_created_at TEXT,"
        "product_created_by TEXT,"
        "product_updated_at TEXT,"
        "product_updated_by TEXT,"
        "product_deleted_at TEXT"
        ")");
    await db.execute("CREATE TABLE warehouse("
        "warehouse_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "warehouse_name TEXT,"
        "warehouse_description TEXT,"
        "warehouse_server_id INTEGER,"
        "warehouse_created_at TEXT,"
        "warehouse_created_by TEXT,"
        "warehouse_updated_at TEXT,"
        "warehouse_updated_by TEXT,"
        "warehouse_deleted_at TEXT,"
        "warehouse_sync INTEGER"
        ")");
    await db.execute("CREATE TABLE area("
        "area_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "area_name TEXT,"
        "area_description TEXT,"
        "area_warehouse_id INTEGER,"
        "area_server_id INTEGER,"
        "area_created_at TEXT,"
        "area_created_by TEXT,"
        "area_updated_at TEXT,"
        "area_updated_by TEXT,"
        "area_deleted_at TEXT"
        ")");
    await db.execute("CREATE TABLE line("
        "line_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "line_name TEXT,"
        "line_description TEXT,"
        "line_server_id INTEGER,"
        "line_created_at TEXT,"
        "line_created_by TEXT,"
        "line_updated_at TEXT,"
        "line_updated_by TEXT,"
        "line_deleted_at TEXT"
        ")");
    await db.execute("CREATE TABLE production("
        "production_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "production_code TEXT,"
        "production_time TEXT,"
        "production_product_id INTEGER,"
        "production_line_id INTEGER,"
        "production_shift TEXT,"
        "production_batch TEXT,"
        "production_qty INTEGER,"
        "production_remark TEXT,"
        "production_user_id INTEGER,"
        "production_server_id INTEGER,"
        "production_created_at TEXT,"
        "production_created_by TEXT,"
        "production_updated_at TEXT,"
        "production_updated_by TEXT,"
        "production_deleted_at TEXT,"
        "production_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE transfer("
        "transfer_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "transfer_code TEXT,"
        "transfer_time TEXT,"
        "transfer_sent_at TEXT,"
        "transfer_user_id INTEGER,"
        "transfer_server_id INTEGER,"
        "transfer_created_at TEXT,"
        "transfer_created_by TEXT,"
        "transfer_updated_at TEXT,"
        "transfer_updated_by TEXT,"
        "transfer_deleted_at TEXT,"
        "transfer_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE transferdet("
        "transferdet_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "transferdet_code TEXT,"
        "transferdet_transfer_id INTEGER,"
        "transferdet_product_id INTEGER,"
        "transferdet_qty INTEGER,"
        "transferdet_server_id INTEGER,"
        "transferdet_created_at TEXT,"
        "transferdet_created_by TEXT,"
        "transferdet_updated_at TEXT,"
        "transferdet_updated_by TEXT,"
        "transferdet_deleted_at TEXT,"
        "transferdet_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE receipt("
        "receipt_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "receipt_code TEXT,"
        "receipt_transfer_id INTEGER,"
        "receipt_transfer_code TEXT,"
        "receipt_user_id INTEGER,"
        "receipt_status INTEGER,"
        "receipt_time TEXT,"
        "receipt_server_id INTEGER,"
        "receipt_created_at TEXT,"
        "receipt_created_by TEXT,"
        "receipt_updated_at TEXT,"
        "receipt_updated_by TEXT,"
        "receipt_deleted_at TEXT,"
        "receipt_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE receiptdet("
        "receiptdet_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "receiptdet_code TEXT,"
        "receiptdet_receipt_id INTEGER,"
        "receiptdet_transferdet_id INTEGER,"
        "receiptdet_product_id INTEGER,"
        "receiptdet_qty INTEGER,"
        "receiptdet_note TEXT,"
        "receiptdet_server_id INTEGER,"
        "receiptdet_created_at TEXT,"
        "receiptdet_created_by TEXT,"
        "receiptdet_updated_at TEXT,"
        "receiptdet_updated_by TEXT,"
        "receiptdet_deleted_at TEXT"
        ")");

    await db.execute("CREATE TABLE allocation("
        "allocation_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "allocation_code TEXT,"
        "allocation_product_id INTEGER,"
        "allocation_user_id INTEGER,"
        "allocation_time TEXT,"
        "allocation_server_id INTEGER,"
        "allocation_created_at TEXT,"
        "allocation_created_by TEXT,"
        "allocation_updated_at TEXT,"
        "allocation_updated_by TEXT,"
        "allocation_deleted_at TEXT,"
        "allocation_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE allocationdet("
        "allocationdet_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "allocationdet_code TEXT,"
        "allocationdet_allocation_id INTEGER,"
        "allocationdet_area_id INTEGER,"
        "allocationdet_qty INTEGER,"
        "allocationdet_server_id INTEGER,"
        "allocationdet_created_at TEXT,"
        "allocationdet_created_by TEXT,"
        "allocationdet_updated_at TEXT,"
        "allocationdet_updated_by TEXT,"
        "allocationdet_deleted_at TEXT"
        ")");

    await db.execute("CREATE TABLE delivery("
        "delivery_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "delivery_code TEXT,"
        "delivery_time TEXT,"
        "delivery_expedition TEXT,"
        "delivery_destination TEXT,"
        "delivery_city TEXT,"
        "delivery_user_id INTEGER,"
        "delivery_server_id INTEGER,"
        "delivery_created_at TEXT,"
        "delivery_created_by TEXT,"
        "delivery_updated_at TEXT,"
        "delivery_updated_by TEXT,"
        "delivery_deleted_at TEXT,"
        "delivery_sync INTEGER DEFAULT 0"
        ")");

    await db.execute("CREATE TABLE deliverydet("
        "deliverydet_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "deliverydet_code TEXT,"
        "deliverydet_delivery_id INTEGER,"
        "deliverydet_product_id INTEGER,"
        "deliverydet_qty INTEGER,"
        "deliverydet_area_id INTEGER,"
        "deliverydet_server_id INTEGER,"
        "deliverydet_created_at TEXT,"
        "deliverydet_created_by TEXT,"
        "deliverydet_updated_at TEXT,"
        "deliverydet_updated_by TEXT,"
        "deliverydet_deleted_at TEXT"
        ")");

    await db.execute("CREATE TABLE area_product_qty("
        "warehouse_id INTEGER,"
        "area_id INTEGER,"
        "product_id INTEGER,"
        "quantity INTEGER,"
        "created_at TEXT,"
        "created_by TEXT,"
        "updated_at TEXT,"
        "updated_by TEXT"
        ")");

    await db.execute("CREATE TABLE sj_number("
        "delivery_id INTEGER PRIMARY KEY,"
        "surat_jalan TEXT,"
        "order_item TEXT,"
        "schedule_shipdate TEXT,"
        "party_name TEXT,"
        "address TEXT,"
        "on_or_about TEXT,"
        "unit_selling_price INTEGER,"
        "ship_quantity INTEGER,"
        "ship_quantity_check INTEGER,"
        "type_truck TEXT,"
        "nopol TEXT,"
        "driver TEXT,"
        "code_truck TEXT,"
        "line_number TEXT,"
        "delivery_created_at TEXT,"
        "delivery_updated_at TEXT,"
        "delivery_deleted_at TEXT,"
        "delivery_sync INTEGER"
        ")");
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(
      String table, String columnId, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String columnId, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future dummyData(Database db) async {
    await db.execute("DELETE FROM delivery");
    await db.execute("DELETE FROM deliverydet");
    /*await db.execute(
        "INSERT INTO production (production_code, production_time, production_product_id, production_line_id, production_shift, production_batch, production_qty, production_sync) "
            "VALUES ('Asd123456', '2019-10-18 00:00:00', 1, 1, '1', 'Lot 1', 150, 0)"
    );
    await db.execute(
        "INSERT INTO production (production_code, production_time, production_product_id, production_line_id, production_shift, production_batch, production_qty, production_sync) "
            "VALUES ('Asd123455', '2019-10-20 00:00:00', 1, 1, '1', 'Lot 1', 150, 1)"
    );
    await db.execute(
        "INSERT INTO production (production_code, production_time, production_product_id, production_line_id, production_shift, production_batch, production_qty, production_sync) "
            "VALUES ('Asd123454', '2019-10-18 00:00:00', 1, 1, '1', 'Lot 1', 150, 1)"
    );

     */
  }
}
