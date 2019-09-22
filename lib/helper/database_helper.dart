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
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE product("
        "product_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "product_code TEXT,"
        "product_description TEXT,"
        "product_server_id INTEGER,"
        "product_created_at TEXT,"
        "product_created_by TEXT,"
        "product_updated_at TEXT,"
        "product_updated_by TEXT,"
        "product_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE warehouse("
        "warehouse_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "warehouse_name TEXT,"
        "warehouse_description TEXT,"
        "warehouse_server_id INTEGER,"
        "warehouse_created_at TEXT,"
        "warehouse_created_by TEXT,"
        "warehouse_updated_at TEXT,"
        "warehouse_updated_by TEXT,"
        "warehouse_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE pallet("
        "pallet_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "pallet_name TEXT,"
        "pallet_description TEXT,"
        "pallet_server_id INTEGER,"
        "pallet_created_at TEXT,"
        "pallet_created_by TEXT,"
        "pallet_updated_at TEXT,"
        "pallet_updated_by TEXT,"
        "pallet_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE production("
        "production_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "production_code TEXT,"
        "production_time TEXT,"
        "production_product_id INTEGER,"
        "production_line_id INTEGER,"
        "production_shift TEXT,"
        "production_batch TEXT,"
        "production_qty INTEGER,"
        "production_user_id INTEGER,"
        "production_server_id INTEGER,"
        "pallet_created_at TEXT,"
        "pallet_created_by TEXT,"
        "pallet_updated_at TEXT,"
        "pallet_updated_by TEXT,"
        "pallet_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE transfer("
        "transfer_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "transfer_code TEXT,"
        "transfer_time TEXT,"
        "transfer_user_id INTEGER,"
        "transfer_server_id INTEGER,"
        "transfer_created_at TEXT,"
        "transfer_created_by TEXT,"
        "transfer_updated_at TEXT,"
        "transfer_updated_by TEXT,"
        "transfer_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE transferdet("
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
        "transferdet_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE receipt("
        "receipt_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "receipt_code TEXT,"
        "receipt_transfer_id INTEGER,"
        "receipt_user_id INTEGER,"
        "receipt_status INTEGER,"
        "receipt_time TEXT,"
        "receipt_server_id INTEGER,"
        "receipt_created_at TEXT,"
        "receipt_created_by TEXT,"
        "receipt_updated_at TEXT,"
        "receipt_updated_by TEXT,"
        "receipt_deleted_at TEXT"
        ")"
    );
    await db.execute(
      "CREATE TABLE receiptdet("
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
        ")"
    );
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, String columnId, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, String columnId, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}