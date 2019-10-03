class WarehouseModel {
  WarehouseModel._privateConstructor();
  static final WarehouseModel instance = WarehouseModel._privateConstructor();

  final String tableName = 'warehouse';
  int warehouse_id;
  String warehouse_name;
  String warehouse_description;
  int warehouse_server_id;
  String warehouse_created_at;
  String warehouse_created_by;
  String warehouse_updated_at;
  String warehouse_updated_by;
  String warehouse_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'warehouse_id': warehouse_id,
      'warehouse_name': warehouse_name,
      'warehouse_description': warehouse_description,
      'warehouse_server_id': warehouse_server_id,
      'warehouse_created_at': warehouse_created_at,
      'warehouse_created_by': warehouse_created_by,
      'warehouse_updated_at': warehouse_updated_at,
      'warehouse_updated_by': warehouse_updated_by,
      'warehouse_deleted_at': warehouse_deleted_at,
    };
  }

  WarehouseModel.fromDb(Map<String, dynamic> map)
      : warehouse_id = map['warehouse_id'],
        warehouse_name = map['warehouse_name'],
        warehouse_description = map['warehouse_description'],
        warehouse_server_id = map['warehouse_server_id'],
        warehouse_created_at = map['warehouse_created_at'],
        warehouse_created_by = map['warehouse_created_by'],
        warehouse_updated_at = map['warehouse_updated_at'],
        warehouse_updated_by = map['warehouse_updated_by'],
        warehouse_deleted_at = map['warehouse_deleted_at'];
}