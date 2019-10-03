import 'dart:math';

class AreaProductQtyModel {
  AreaProductQtyModel._privateConstructor();
  static final AreaProductQtyModel instance = AreaProductQtyModel._privateConstructor();

  final String tableName = 'area_product_qty';
  int warehouse_id;
  int area_id;
  int product_id;
  int quantity;

  Map<String, dynamic> toMap() {
    return {
      'warehouse_id': warehouse_id,
      'area_id': area_id,
      'product_id': product_id,
      'quantity': quantity
    };
  }

  AreaProductQtyModel.fromDb(Map<String, dynamic> map)
      : warehouse_id = map['warehouse_id'],
        area_id = map['area_id'],
        product_id = map['product_id'],
        quantity = map['quantity'];

  AreaProductQtyModel.random(){
    this.warehouse_id = 1 + Random().nextInt(2);
    this.area_id = 1 + Random().nextInt(5);
    this.product_id = 1 + Random().nextInt(6);
    this.quantity = 10 + Random().nextInt(20);
  }
}