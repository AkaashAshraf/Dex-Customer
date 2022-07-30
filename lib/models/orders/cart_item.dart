import 'package:customers/models/product.dart';

class CartItem {
  int id;
  int quantity;
  double total;
  Product product;
  String note;
  int refrence;
  List<CartItem> children;

  CartItem(this.id, this.product, this.quantity, this.total, this.note,
      this.refrence, this.children);
}
