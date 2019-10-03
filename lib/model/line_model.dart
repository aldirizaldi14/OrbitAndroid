class LineModel {
  LineModel._privateConstructor();
  static final LineModel instance = LineModel._privateConstructor();

  final String tableName = 'line';
  int line_id;
  String line_name;
  String line_description;
  int line_warehouse_id;
  int line_server_id;
  String line_created_at;
  String line_created_by;
  String line_updated_at;
  String line_updated_by;
  String line_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'line_id': line_id,
      'line_name': line_name,
      'line_description': line_description,
      'line_warehouse_id': line_warehouse_id,
      'line_server_id': line_server_id,
      'line_created_at': line_created_at,
      'line_created_by': line_created_by,
      'line_updated_at': line_updated_at,
      'line_updated_by': line_updated_by,
      'line_deleted_at': line_deleted_at,
    };
  }

  LineModel.fromDb(Map<String, dynamic> map)
      : line_id = map['line_id'],
        line_name = map['line_name'],
        line_description = map['line_description'],
        line_warehouse_id = map['line_warehouse_id'],
        line_server_id = map['line_server_id'],
        line_created_at = map['line_created_at'],
        line_created_by = map['line_created_by'],
        line_updated_at = map['line_updated_at'],
        line_updated_by = map['line_updated_by'],
        line_deleted_at = map['line_deleted_at'];
}