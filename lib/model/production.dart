import 'dart:math';

class Production {
  final String tableName = 'production';

  int production_id;
  String production_code;
  String production_time;
  int production_product_id;
  int production_line_id;
  String production_shift;
  String production_batch;
  int production_qty;
  int production_user_id;
  int production_server_id;
  String pallet_created_at;
  String pallet_created_by;
  String pallet_updated_at;
  String pallet_updated_by;
  String pallet_deleted_at;

  Production(
    this.production_id,
    this.production_code,
    this.production_time,
    this.production_product_id
  );

  /*Production({
    this.production_id,
    this.production_code,
    this.production_time,
    this.production_product_id,
    this.production_line_id,
    this.production_shift,
    this.production_batch,
    this.production_qty,
    this.production_user_id,
  });*/

  Map<String, dynamic> toMap() {
    return {
      'production_id': production_id,
      'production_code': production_code,
      'production_time': production_time,
      'production_product_id': production_product_id,
      'production_line_id': production_line_id,
      'production_shift': production_shift,
      'production_batch': production_batch,
      'production_qty': production_qty,
      'production_user_id': production_user_id,
      'production_server_id': production_server_id,
      'pallet_created_at': pallet_created_at,
      'pallet_created_by': pallet_created_by,
      'pallet_updated_at': pallet_updated_at,
      'pallet_updated_by': pallet_updated_by,
      'pallet_deleted_at': pallet_deleted_at,
    };
  }

  Production.fromDb(Map<String, dynamic> map)
      : production_id = map['production_id'],
        production_code = map['production_code'],
        production_time = map['production_time'],
        production_product_id = map['production_product_id'],
        production_line_id = map['production_line_id'],
        production_shift = map['production_shift'],
        production_batch = map['production_batch'],
        production_qty = map['production_qty'],
        production_user_id = map['production_user_id'],
        production_server_id = map['production_server_id'],
        pallet_created_at = map['pallet_created_at'],
        pallet_created_by = map['pallet_created_by'],
        pallet_updated_at = map['pallet_updated_at'],
        pallet_updated_by = map['pallet_updated_by'],
        pallet_deleted_at = map['pallet_deleted_at'];

  Production.random(){
    this.production_id = null;
    this.production_code = 'P'+ (1 + Random().nextInt(30)).toString();
    this.production_time = '23-09-2019 00:00:00';
    this.production_qty = 10 + Random().nextInt(20);
    this.production_product_id = 1 + Random().nextInt(6);
  }
}