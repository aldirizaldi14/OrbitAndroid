class ReceiptdetModel {
  ReceiptdetModel._privateConstructor();
  static final ReceiptdetModel instance = ReceiptdetModel._privateConstructor();

  final String tableName = 'receiptdet';
  int receiptdet_id;
  String receiptdet_code;
  int receiptdet_receipt_id;
  int receiptdet_product_id;
  int receiptdet_transferdet_id;
  int receiptdet_qty;
  String receiptdet_note;
  int receiptdet_server_id;
  String receiptdet_created_at;
  String receiptdet_created_by;
  String receiptdet_updated_at;
  String receiptdet_updated_by;
  String receiptdet_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'receiptdet_id': receiptdet_id,
      'receiptdet_code': receiptdet_code,
      'receiptdet_receipt_id': receiptdet_receipt_id,
      'receiptdet_product_id': receiptdet_product_id,
      'receiptdet_transferdet_id': receiptdet_transferdet_id,
      'receiptdet_qty': receiptdet_qty,
      'receiptdet_note': receiptdet_note,
      'receiptdet_server_id': receiptdet_server_id,
      'receiptdet_created_at': receiptdet_created_at,
      'receiptdet_created_by': receiptdet_created_by,
      'receiptdet_updated_at': receiptdet_updated_at,
      'receiptdet_updated_by': receiptdet_updated_by,
      'receiptdet_deleted_at': receiptdet_deleted_at,
    };
  }

  ReceiptdetModel.fromDb(Map<String, dynamic> map)
      : receiptdet_id = map['receiptdet_id'],
        receiptdet_code = map['receiptdet_code'],
        receiptdet_receipt_id = map['receiptdet_receipt_id'] is int ? map['receiptdet_receipt_id'] : (map['receiptdet_receipt_id'] == null ? 0 : int.parse(map['receiptdet_receipt_id'])),
        receiptdet_product_id = map['receiptdet_product_id'] is int ? map['receiptdet_product_id'] : (map['receiptdet_product_id'] == null ? 0 : int.parse(map['receiptdet_product_id'])),
        receiptdet_transferdet_id = map['receiptdet_transferdet_id'] is int ? map['receiptdet_transferdet_id'] : (map['receiptdet_transferdet_id'] == null ? 0 : int.parse(map['receiptdet_transferdet_id'])),
        receiptdet_qty = map['receiptdet_qty'] is int ? map['receiptdet_qty'] : (map['receiptdet_qty'] == null ? 0 : int.parse(map['receiptdet_qty'])),
        receiptdet_note = map['receiptdet_note'].toString(),
        receiptdet_server_id = map['receiptdet_server_id'],
        receiptdet_created_at = map['receiptdet_created_at'],
        receiptdet_created_by = map['receiptdet_created_by'],
        receiptdet_updated_at = map['receiptdet_updated_at'],
        receiptdet_updated_by = map['receiptdet_updated_by'],
        receiptdet_deleted_at = map['receiptdet_deleted_at'];
}