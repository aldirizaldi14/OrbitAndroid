class AllocationdetModel {
  AllocationdetModel._privateConstructor();
  static final AllocationdetModel instance = AllocationdetModel._privateConstructor();

  final String tableName = 'allocationdet';
  int allocationdet_id;
  String allocationdet_code;
  int allocationdet_allocation_id;
  int allocationdet_area_id;
  int allocationdet_qty;
  int allocationdet_server_id;
  String allocationdet_created_at;
  String allocationdet_created_by;
  String allocationdet_updated_at;
  String allocationdet_updated_by;
  String allocationdet_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'allocationdet_id': allocationdet_id,
      'allocationdet_code': allocationdet_code,
      'allocationdet_allocation_id': allocationdet_allocation_id,
      'allocationdet_area_id': allocationdet_area_id,
      'allocationdet_qty': allocationdet_qty,
      'allocationdet_server_id': allocationdet_server_id,
      'allocationdet_created_at': allocationdet_created_at,
      'allocationdet_created_by': allocationdet_created_by,
      'allocationdet_updated_at': allocationdet_updated_at,
      'allocationdet_updated_by': allocationdet_updated_by,
      'allocationdet_deleted_at': allocationdet_deleted_at,
    };
  }

  AllocationdetModel.fromDb(Map<String, dynamic> map)
      : allocationdet_id = map['allocationdet_id'],
        allocationdet_code = map['allocationdet_code'],
        allocationdet_allocation_id = map['allocationdet_allocation_id'],
        allocationdet_area_id = map['allocationdet_area_id'],
        allocationdet_qty = map['allocationdet_qty'],
        allocationdet_server_id = map['allocationdet_server_id'],
        allocationdet_created_at = map['allocationdet_created_at'],
        allocationdet_created_by = map['allocationdet_created_by'],
        allocationdet_updated_at = map['allocationdet_updated_at'],
        allocationdet_updated_by = map['allocationdet_updated_by'],
        allocationdet_deleted_at = map['allocationdet_deleted_at'];
}