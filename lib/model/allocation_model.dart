class AllocationModel {
  AllocationModel._privateConstructor();
  static final AllocationModel instance = AllocationModel._privateConstructor();
  
  final String tableName = 'allocation';
  int allocation_id;
  String allocation_code;
  int allocation_product_id;
  int allocation_user_id;
  String allocation_time;
  int allocation_server_id;
  String allocation_created_at;
  String allocation_created_by;
  String allocation_updated_at;
  String allocation_updated_by;
  String allocation_deleted_at;
  int allocation_sync;

  Map<String, dynamic> toMap() {
    return {
      'allocation_id': allocation_id,
      'allocation_code': allocation_code,
      'allocation_product_id': allocation_product_id,
      'allocation_user_id': allocation_user_id,
      'allocation_time': allocation_time,
      'allocation_server_id': allocation_server_id,
      'allocation_created_at': allocation_created_at,
      'allocation_created_by': allocation_created_by,
      'allocation_updated_at': allocation_updated_at,
      'allocation_updated_by': allocation_updated_by,
      'allocation_deleted_at': allocation_deleted_at,
      'allocation_sync': allocation_sync,
    };
  }

  AllocationModel.fromDb(Map<String, dynamic> map)
      : allocation_id = map['allocation_id'],
        allocation_code = map['allocation_code'],
        allocation_product_id = map['allocation_product_id'],
        allocation_user_id = map['allocation_user_id'],
        allocation_time = map['allocation_time'],
        allocation_server_id = map['allocation_server_id'],
        allocation_created_at = map['allocation_created_at'],
        allocation_created_by = map['allocation_created_by'],
        allocation_updated_at = map['allocation_updated_at'],
        allocation_updated_by = map['allocation_updated_by'],
        allocation_deleted_at = map['allocation_deleted_at'],
        allocation_sync = map['allocation_sync'];
}