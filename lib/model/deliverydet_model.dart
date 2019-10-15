class DeliverydetModel {
  DeliverydetModel._privateConstructor();
  static final DeliverydetModel instance = DeliverydetModel._privateConstructor();

  final String tableName = 'deliverydet';
  int deliverydet_id;
  String deliverydet_code;
  int deliverydet_delivery_id;
  int deliverydet_product_id;
  int deliverydet_qty;
  int deliverydet_server_id;
  String deliverydet_created_at;
  String deliverydet_created_by;
  String deliverydet_updated_at;
  String deliverydet_updated_by;
  String deliverydet_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'deliverydet_id': deliverydet_id,
      'deliverydet_code': deliverydet_code,
      'deliverydet_delivery_id': deliverydet_delivery_id,
      'deliverydet_product_id': deliverydet_product_id,
      'deliverydet_qty': deliverydet_qty,
      'deliverydet_server_id': deliverydet_server_id,
      'deliverydet_created_at': deliverydet_created_at,
      'deliverydet_created_by': deliverydet_created_by,
      'deliverydet_updated_at': deliverydet_updated_at,
      'deliverydet_updated_by': deliverydet_updated_by,
      'deliverydet_deleted_at': deliverydet_deleted_at,
    };
  }

  DeliverydetModel.fromDb(Map<String, dynamic> map)
      : deliverydet_id = map['deliverydet_id'],
        deliverydet_code = map['deliverydet_code'],
        deliverydet_delivery_id = map['deliverydet_delivery_id'],
        deliverydet_product_id = map['deliverydet_product_id'],
        deliverydet_qty = map['deliverydet_qty'],
        deliverydet_server_id = map['deliverydet_server_id'],
        deliverydet_created_at = map['deliverydet_created_at'],
        deliverydet_created_by = map['deliverydet_created_by'],
        deliverydet_updated_at = map['deliverydet_updated_at'],
        deliverydet_updated_by = map['deliverydet_updated_by'],
        deliverydet_deleted_at = map['deliverydet_deleted_at'];
}