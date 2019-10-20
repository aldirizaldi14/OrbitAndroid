class ReceiptModel {
  ReceiptModel._privateConstructor();
  static final ReceiptModel instance = ReceiptModel._privateConstructor();

  final String tableName = 'receipt';
  int receipt_id;
  String receipt_code;
  int receipt_status;
  String receipt_time;
  int receipt_transfer_id;
  String receipt_transfer_code;
  int receipt_user_id;
  int receipt_server_id;
  String receipt_created_at;
  String receipt_created_by;
  String receipt_updated_at;
  String receipt_updated_by;
  String receipt_deleted_at;
  int receipt_sync;

  Map<String, dynamic> toMap() {
    return {
      'receipt_id': receipt_id,
      'receipt_code': receipt_code,
      'receipt_status': receipt_status,
      'receipt_time': receipt_time,
      'receipt_transfer_id': receipt_transfer_id,
      'receipt_transfer_code': receipt_transfer_code,
      'receipt_user_id': receipt_user_id,
      'receipt_server_id': receipt_server_id,
      'receipt_created_at': receipt_created_at,
      'receipt_created_by': receipt_created_by,
      'receipt_updated_at': receipt_updated_at,
      'receipt_updated_by': receipt_updated_by,
      'receipt_deleted_at': receipt_deleted_at,
      'receipt_sync': receipt_sync,
    };
  }

  ReceiptModel.fromDb(Map<String, dynamic> map)
      : receipt_id = map['receipt_id'],
        receipt_code = map['receipt_code'],
        receipt_status = map['receipt_status'] is int ? map['receipt_status'] : (map['receipt_status'] == null ? 0 : int.parse(map['receipt_status'])),
        receipt_time = map['receipt_time'],
        receipt_transfer_id = map['receipt_transfer_id'] is int ? map['receipt_transfer_id'] : (map['receipt_transfer_id'] == null ? 0 : int.parse(map['receipt_transfer_id'])),
        receipt_transfer_code = map['receipt_transfer_code'],
        receipt_user_id = map['receipt_user_id'] is int ? map['receipt_user_id'] : (map['receipt_user_id'] == null ? 0 : int.parse(map['receipt_user_id'])),
        receipt_server_id = map['receipt_server_id'],
        receipt_created_at = map['receipt_created_at'],
        receipt_created_by = map['receipt_created_by'],
        receipt_updated_at = map['receipt_updated_at'],
        receipt_updated_by = map['receipt_updated_by'],
        receipt_deleted_at = map['receipt_deleted_at'],
        receipt_sync = map['receipt_sync'] is int ? map['receipt_sync'] : (map['receipt_sync'] == null ? 0 : int.parse(map['receipt_sync']));
}