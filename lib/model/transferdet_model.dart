class TransferdetModel {
  TransferdetModel._privateConstructor();
  static final TransferdetModel instance = TransferdetModel._privateConstructor();

  final String tableName = 'transferdet';
  int transferdet_id;
  String transferdet_code;
  int transferdet_transfer_id;
  int transferdet_product_id;
  int transferdet_qty;
  int transferdet_server_id;
  String transferdet_created_at;
  String transferdet_created_by;
  String transferdet_updated_at;
  String transferdet_updated_by;
  String transferdet_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'transferdet_id': transferdet_id,
      'transferdet_code': transferdet_code,
      'transferdet_transfer_id': transferdet_transfer_id,
      'transferdet_product_id': transferdet_product_id,
      'transferdet_qty': transferdet_qty,
      'transferdet_server_id': transferdet_server_id,
      'transferdet_created_at': transferdet_created_at,
      'transferdet_created_by': transferdet_created_by,
      'transferdet_updated_at': transferdet_updated_at,
      'transferdet_updated_by': transferdet_updated_by,
      'transferdet_deleted_at': transferdet_deleted_at,
    };
  }

  TransferdetModel.fromDb(Map<String, dynamic> map)
      : transferdet_id = map['transferdet_id'],
        transferdet_code = map['transferdet_code'],
        transferdet_transfer_id = map['transferdet_transfer_id'] is int ? map['transferdet_transfer_id'] : int.parse(map['transferdet_transfer_id']),
        transferdet_product_id = map['transferdet_product_id'] is int ? map['transferdet_product_id'] : int.parse(map['transferdet_product_id']),
        transferdet_qty = map['transferdet_qty'] is int ? map['transferdet_qty'] : int.parse(map['transferdet_qty']),
        transferdet_server_id = map['transferdet_server_id'],
        transferdet_created_at = map['transferdet_created_at'],
        transferdet_created_by = map['transferdet_created_by'],
        transferdet_updated_at = map['transferdet_updated_at'],
        transferdet_updated_by = map['transferdet_updated_by'],
        transferdet_deleted_at = map['transferdet_deleted_at'];
}