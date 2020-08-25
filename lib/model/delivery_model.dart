class DeliveryModel {
  DeliveryModel._privateConstructor();
  static final DeliveryModel instance = DeliveryModel._privateConstructor();

  final String tableName = 'sj_number';
  int delivery_id;
  String surat_jalan;
  String order_item;
  DateTime schedule_shipdate;
  String party_name;
  String address;
  DateTime on_or_about;
  int unit_selling_price;
  int ship_quantity;
  int ship_quantity_check;
  String type_truck;
  String nopol;
  String driver;
  int delivery_sync;

  /*int delivery_user_id;
  int delivery_server_id;*/
  String delivery_created_at;
  String delivery_created_by;
  String delivery_updated_at;
  String delivery_updated_by;
  String delivery_deleted_at;
  //int delivery_sync;

  Map<String, dynamic> toMap() {
    return {
      'delivery_id': delivery_id,
      'surat_jalan': surat_jalan,
      'order_item': order_item,
      'schedule_shipdate': schedule_shipdate,
      'party_name': party_name,
      'address': address,
      'on_or_about': on_or_about,
      'unit_selling_price': unit_selling_price,
      'ship_quantity': ship_quantity,
      'ship_quantity_check': ship_quantity_check,
      'type_truck': type_truck,
      'nopol': nopol,
      'driver': driver,
      'delivery_sync': delivery_sync,
      /*'delivery_user_id': delivery_user_id,
      'delivery_server_id': delivery_server_id,*/
      'delivery_created_at': delivery_created_at,
      'delivery_created_by': delivery_created_by,
      'delivery_updated_at': delivery_updated_at,
      'delivery_updated_by': delivery_updated_by,
      'delivery_deleted_at': delivery_deleted_at,
      //'delivery_sync': delivery_sync,
    };
  }

  DeliveryModel.fromDb(Map<String, dynamic> map)
      : delivery_id = map['delivery_id'],
        surat_jalan = map['surat_jalan'],
        order_item = map['order_item'],
        schedule_shipdate = map['schedule_shipdate'],
        party_name = map['party_name'],
        address = map['address'],
        on_or_about = map['on_or_about'],
        unit_selling_price = map['unit_selling_price'],
        ship_quantity = map['ship_quantity'],
        ship_quantity_check = map['ship_quantity_check'],
        type_truck = map['type_truck'],
        nopol = map['nopol'],
        driver = map['driver'],
        /*delivery_user_id = map['delivery_user_id'] is int
            ? map['delivery_user_id']
            : (map['delivery_user_id'] == null
                ? 0
                : int.parse(map['delivery_user_id'])),
        delivery_server_id = map['delivery_server_id'],*/
        delivery_created_at = map['delivery_created_at'],
        delivery_created_by = map['delivery_created_by'],
        delivery_updated_at = map['delivery_updated_at'],
        delivery_updated_by = map['delivery_updated_by'],
        delivery_deleted_at = map['delivery_deleted_at'],
        delivery_sync = map['delivery_sync'] is int
            ? map['delivery_sync']
            : (map['delivery_sync'] == null
                ? 0
                : int.parse(map['delivery_sync']));
}

/*class DeliveryModel {
  DeliveryModel._privateConstructor();
  static final DeliveryModel instance = DeliveryModel._privateConstructor();

  final String tableName = 'delivery';
  int delivery_id;
  String delivery_code;
  String delivery_item;
  DateTime delivery_expedition;
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
      'delivery_item': delivery_item,
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
        delivery_item = map['delivery_item'],
        delivery_expedition = map['delivery_expedition'],
        delivery_destination = map['delivery_destination'],
        delivery_city = map['delivery_city'],
        delivery_user_id = map['delivery_user_id'] is int
            ? map['delivery_user_id']
            : (map['delivery_user_id'] == null
                ? 0
                : int.parse(map['delivery_user_id'])),
        delivery_server_id = map['delivery_server_id'],
        delivery_created_at = map['delivery_created_at'],
        delivery_created_by = map['delivery_created_by'],
        delivery_updated_at = map['delivery_updated_at'],
        delivery_updated_by = map['delivery_updated_by'],
        delivery_deleted_at = map['delivery_deleted_at'],
        delivery_sync = map['delivery_sync'] is int
            ? map['delivery_sync']
            : (map['delivery_sync'] == null
                ? 0
                : int.parse(map['delivery_sync']));
}*/
