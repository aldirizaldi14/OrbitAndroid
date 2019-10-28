class ProductModel {
  ProductModel._privateConstructor();
  static final ProductModel instance = ProductModel._privateConstructor();

  final String tableName = 'product';
  int product_id;
  String product_code;
  String product_code_alt;
  String product_description;
  int product_server_id;
  String product_created_at;
  String product_created_by;
  String product_updated_at;
  String product_updated_by;
  String product_deleted_at;

  Map<String, dynamic> toMap() {
    return {
      'product_id': product_id,
      'product_code': product_code,
      'product_code_alt': product_code_alt,
      'product_description': product_description,
      'product_server_id': product_server_id,
      'product_created_at': product_created_at,
      'product_created_by': product_created_by,
      'product_updated_at': product_updated_at,
      'product_updated_by': product_updated_by,
      'product_deleted_at': product_deleted_at,
    };
  }

  ProductModel.fromDb(Map<String, dynamic> map)
      : product_id = map['product_id'],
        product_code = map['product_code'],
        product_code_alt = map['product_code_alt'],
        product_description = map['product_description'],
        product_server_id = map['product_server_id'],
        product_created_at = map['product_created_at'],
        product_created_by = map['product_created_by'],
        product_updated_at = map['product_updated_at'],
        product_updated_by = map['product_updated_by'],
        product_deleted_at = map['product_deleted_at'];
}