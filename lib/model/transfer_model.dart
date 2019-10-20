class TransferModel {
  TransferModel._privateConstructor();
  static final TransferModel instance = TransferModel._privateConstructor();

  final String tableName = 'transfer';
  int transfer_id;
  String transfer_code;
  String transfer_time;
  String transfer_sent_at;
  int transfer_user_id;
  int transfer_server_id;
  String transfer_created_at;
  String transfer_created_by;
  String transfer_updated_at;
  String transfer_updated_by;
  String transfer_deleted_at;
  int transfer_sync;

  Map<String, dynamic> toMap() {
    return {
      'transfer_id': transfer_id,
      'transfer_code': transfer_code,
      'transfer_time': transfer_time,
      'transfer_sent_at': transfer_sent_at,
      'transfer_user_id': transfer_user_id,
      'transfer_server_id': transfer_server_id,
      'transfer_created_at': transfer_created_at,
      'transfer_created_by': transfer_created_by,
      'transfer_updated_at': transfer_updated_at,
      'transfer_updated_by': transfer_updated_by,
      'transfer_deleted_at': transfer_deleted_at,
      'transfer_sync': transfer_sync,
    };
  }

  TransferModel.fromDb(Map<String, dynamic> map)
      : transfer_id = map['transfer_id'],
        transfer_code = map['transfer_code'],
        transfer_time = map['transfer_time'],
        transfer_sent_at = map['transfer_sent_at'],
        transfer_user_id = map['transfer_user_id'] is int ? map['transfer_user_id'] : (map['transfer_user_id'] == null ? 0 : int.parse(map['transfer_user_id'])),
        transfer_server_id = map['transfer_server_id'],
        transfer_created_at = map['transfer_created_at'],
        transfer_created_by = map['transfer_created_by'],
        transfer_updated_at = map['transfer_updated_at'],
        transfer_updated_by = map['transfer_updated_by'],
        transfer_deleted_at = map['transfer_deleted_at'],
        transfer_sync = map['transfer_sync'] is int ? map['transfer_sync'] : int.parse(map['transfer_sync']);
}