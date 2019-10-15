class DeliveryModel {
  DeliveryModel._privateConstructor();
  static final DeliveryModel instance = DeliveryModel._privateConstructor();

  final String tableName = 'delivery';
  int delivery_id;
  String delivery_code;
  String delivery_time;
  String delivery_expedition;
  String delivery_destination;
  String delivery_city;
  int delivery_user_id;
  int delivery_server_id;
  String delivery_created_at;
  String delivery_created_by;
  String delivery_updated_at;
  String delivery_updated_by;
  String delivery_deleted_at;
  int delivery_sync;

  Map<String, dynamic> toMap() {
    return {
      'delivery_id': delivery_id,
      'delivery_code': delivery_code,
      'delivery_time': delivery_time,
      'delivery_expedition': delivery_expedition,
      'delivery_destination': delivery_destination,
      'delivery_city': delivery_city,
      'delivery_user_id': delivery_user_id,
      'delivery_server_id': delivery_server_id,
      'delivery_created_at': delivery_created_at,
      'delivery_created_by': delivery_created_by,
      'delivery_updated_at': delivery_updated_at,
      'delivery_updated_by': delivery_updated_by,
      'delivery_deleted_at': delivery_deleted_at,
      'delivery_sync': delivery_sync,
    };
  }

  DeliveryModel.fromDb(Map<String, dynamic> map)
      : delivery_id = map['delivery_id'],
        delivery_code = map['delivery_code'],
        delivery_time = map['delivery_time'],
        delivery_expedition = map['delivery_expedition'],
        delivery_destination = map['delivery_destination'],
        delivery_city = map['delivery_city'],
        delivery_user_id = map['delivery_user_id'],
        delivery_server_id = map['delivery_server_id'],
        delivery_created_at = map['delivery_created_at'],
        delivery_created_by = map['delivery_created_by'],
        delivery_updated_at = map['delivery_updated_at'],
        delivery_updated_by = map['delivery_updated_by'],
        delivery_deleted_at = map['delivery_deleted_at'],
        delivery_sync = map['delivery_sync'];
}