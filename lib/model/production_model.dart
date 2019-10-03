class ProductionModel {
  ProductionModel._privateConstructor();
  static final ProductionModel instance = ProductionModel._privateConstructor();

  final String tableName = 'production';
  int production_id;
  String production_code;
  String production_time;
  int production_product_id;
  int production_line_id;
  String production_shift;
  String production_batch;
  int production_qty;
  int production_user_id;
  int production_server_id;
  String production_created_at;
  String production_created_by;
  String production_updated_at;
  String production_updated_by;
  String production_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'production_id': production_id,
      'production_code': production_code,
      'production_time': production_time,
      'production_product_id': production_product_id,
      'production_line_id': production_line_id,
      'production_shift': production_shift,
      'production_batch': production_batch,
      'production_qty': production_qty,
      'production_user_id': production_user_id,
      'production_server_id': production_server_id,
      'production_created_at': production_created_at,
      'production_created_by': production_created_by,
      'production_updated_at': production_updated_at,
      'production_updated_by': production_updated_by,
      'production_deleted_at': production_deleted_at,
    };
  }

  ProductionModel.fromDb(Map<String, dynamic> map)
      : production_id = map['production_id'],
        production_code = map['production_code'],
        production_time = map['production_time'],
        production_product_id = map['production_product_id'],
        production_line_id = map['production_line_id'],
        production_shift = map['production_shift'],
        production_batch = map['production_batch'],
        production_qty = map['production_qty'],
        production_user_id = map['production_user_id'],
        production_server_id = map['production_server_id'],
        production_created_at = map['production_created_at'],
        production_created_by = map['production_created_by'],
        production_updated_at = map['production_updated_at'],
        production_updated_by = map['production_updated_by'],
        production_deleted_at = map['production_deleted_at'];
}