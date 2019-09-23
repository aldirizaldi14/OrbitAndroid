import 'dart:math';

class PalletProductQtyModel {
  PalletProductQtyModel._privateConstructor();
  static final PalletProductQtyModel instance = PalletProductQtyModel._privateConstructor();

  final String tableName = 'pallet_product_qty';
  int warehouse_id;
  int pallet_id;
  int product_id;
  int quantity;

  PalletProductQtyModel({this.warehouse_id, this.pallet_id, this.product_id, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'warehouse_id': warehouse_id,
      'pallet_id': pallet_id,
      'product_id': product_id,
      'quantity': quantity
    };
  }

  PalletProductQtyModel.fromDb(Map<String, dynamic> map)
      : warehouse_id = map['warehouse_id'],
        pallet_id = map['pallet_id'],
        product_id = map['product_id'],
        quantity = map['quantity'];

  PalletProductQtyModel.random(){
    this.warehouse_id = 1 + Random().nextInt(2);
    this.pallet_id = 1 + Random().nextInt(5);
    this.product_id = 1 + Random().nextInt(6);
    this.quantity = 10 + Random().nextInt(20);
  }
}