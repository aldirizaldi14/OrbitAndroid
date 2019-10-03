class AreaModel {
  AreaModel._privateConstructor();
  static final AreaModel instance = AreaModel._privateConstructor();

  final String tableName = 'area';
  int area_id;
  String area_name;
  String area_description;
  int area_warehouse_id;
  int area_server_id;
  String area_created_at;
  String area_created_by;
  String area_updated_at;
  String area_updated_by;
  String area_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'area_id': area_id,
      'area_name': area_name,
      'area_description': area_description,
      'area_warehouse_id': area_warehouse_id,
      'area_server_id': area_server_id,
      'area_created_at': area_created_at,
      'area_created_by': area_created_by,
      'area_updated_at': area_updated_at,
      'area_updated_by': area_updated_by,
      'area_deleted_at': area_deleted_at,
    };
  }

  AreaModel.fromDb(Map<String, dynamic> map)
      : area_id = map['area_id'],
        area_name = map['area_name'],
        area_description = map['area_description'],
        area_warehouse_id = map['area_warehouse_id'],
        area_server_id = map['area_server_id'],
        area_created_at = map['area_created_at'],
        area_created_by = map['area_created_by'],
        area_updated_at = map['area_updated_at'],
        area_updated_by = map['area_updated_by'],
        area_deleted_at = map['area_deleted_at'];
}