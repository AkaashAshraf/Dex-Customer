import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/repositories/globals.dart';
import 'package:flutter/material.dart'
    show BuildContext, ChangeNotifier, Colors;
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = <CartItem>[];
  List<CartItem> get cartItems => _cartItems;

  List<CartItem> _parents = [];
  List<CartItem> get parents => _parents;

  List<CartItem> _children = [];
  List<CartItem> get children => _children;

  double _totalCost = 0;
  double get totalCost => _totalCost;


  double _totalCostWithVAT = 0.0;
  double get totalCostWithVAT => _totalCostWithVAT;

    double _totalWithoutVAT = 0.0;
  double get totalWithoutVAT => _totalWithoutVAT;

  int _cartId = 0;
  int get cartId => _cartId;

  int _cartCounter = 0;
  int get cartCounter => _cartCounter;

  List<int> _orderProductList = [];
  List<int> get orderProductList => _orderProductList;

  List<int> _quantity = [];
  List<int> get quantity => _quantity;

  bool _loading = false;
  bool get loading => _loading;

  bool _isCalculated = false;
  bool get isCalculated => _isCalculated;

  List<String> _notes = [];
  List<String> get notes => _notes;

  List<int> _refrences = [];
  List<int> get refrences => _refrences;

  bool _added;
  bool get added => _added;

  void updateCartCounter() {
    print(_cartItems.length);
    int counter = 0;
    _cartItems.forEach((CartItem item) {
      counter += item.quantity;
    });
    _cartCounter = counter;
  }

  void clearCart() {
    _parents.clear();
    children.clear();
    _quantity.clear();
    _orderProductList.clear();
    _notes.clear();
    _cartItems.clear();
    updateCartCounter();
    calculateTotal();
    notifyListeners();
  }

  void removeCartItemById({int itemId}) {
    _cartItems.removeWhere((cartItem) => cartItem.id == itemId);
    checkForChildren(itemId);
    calculateTotal();
    updateCartCounter();
    notifyListeners();
  }

  Future<void> handleCartList(List<CartItem> cartList) async {
    for (int i = 0; i < cartList.length; i++) {
      bool exist = false;
      if (cartList[i].product.parent == 0) {
        addCartItem(cartItem: cartList[i]);
      } else {
        for (var item in _cartItems) {
          if (item.product.id == cartList[i].product.id) {
            exist = true;
            break;
          }
        }
        if (!exist) {
          _cartItems.add(cartList[i]);
        }
      }
    }
    filterCartItems(_cartItems);
  }

  void filterCartItems(List<CartItem> cartItems) {
    _parents.clear();
    _children.clear();
    cartItems.forEach((item) =>
        item.product.parent == 0 ? _parents.add(item) : _children.add(item));
    if (_parents.isEmpty) {
      _children.clear();
      _cartItems.clear();
      _added = false;
    }
    notifyListeners();
  }

  void checkForChildren(int itemId) {
    for (int n = 0; n < _cartItems.length; n++) {
      _cartItems.removeWhere((cartItem) => cartItem.product.parent == itemId);
    }
    filterCartItems(_cartItems);
    notifyListeners();
  }

  bool isInCart;
  bool oldShop;
  int itemIndex;
  void addCartItem({CartItem cartItem}) {
    Function eq = const DeepCollectionEquality.unordered().equals;
    if (_cartItems.length > 0) {
      isInCart = false;
      oldShop = true;
      for (int i = 0; i < _cartItems.length; i++) {
        var _products = [];
        var products = [];
        _cartItems[i].children.forEach((p) => _products.add(p.product));
        cartItem.children.forEach((p) => products.add(p.product));
        if (_cartItems[i].product.shop != cartItem.product.shop) {
          oldShop = false;
          break;
        }
        if (_cartItems[i].product.name == cartItem.product.name &&
            eq(_products, products)) {
          isInCart = true;
          itemIndex = i;
          break;
        }
      }

      if (oldShop) {
        if (isInCart) {
          _cartItems[itemIndex].quantity++;
          var total = _cartItems[itemIndex].quantity *
              _cartItems[itemIndex].product.price.toDouble();
          _cartItems[itemIndex].total = total;
          _added = true;
          notifyListeners();
        } else {
          _cartId++;
          var total = cartItem.quantity * cartItem.product.price.toDouble();
          cartItem.total = total;
          _cartItems.add(cartItem);
          _added = true;
          notifyListeners();
        }
      } else {
        _added = false;
        notifyListeners();
        Fluttertoast.showToast(
          msg: "orderOneShop".tr(),
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } else {
      _cartId++;
      var total = cartItem.quantity * cartItem.product.price.toDouble();
      cartItem.total = total;
      _cartItems.add(cartItem);
      _added = true;
      notifyListeners();
    }

    updateCartCounter();
    calculateTotal();
    notifyListeners();
  }

  void removeCartItem({CartItem cartItem}) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      var total = cartItem.quantity * cartItem.product.price.toDouble();
      cartItem.total = total;
      updateCartCounter();
      calculateTotal();
      notifyListeners();
    }
  }

  void calculateTotal() {
      _totalCost = 0.0;
      _totalCostWithVAT = 0.0;
      _totalWithoutVAT = 0.0;
      if (_cartItems != null) {
        for (int i = 0; i < _cartItems.length; i++) {
          if (_cartItems[i].product.parent == 0) {
            _totalCost += _cartItems[i].total;
            for (int v = 0; v < _cartItems[i].children.length; v++) {
              _totalCost +=
                  _cartItems[i].children[v].total * _cartItems[i].quantity;
            }
          }
        }
      _totalCostWithVAT = _totalCost + (vat * _totalCost);
      _totalWithoutVAT = _totalCost;
      notifyListeners();
    }
  }



  void initOrder() {
    int counter = 0;
    String string = '';
    if (_cartItems != null) {
      _loading = true;
      notifyListeners();
      _orderProductList.clear();
      _quantity.clear();
      _notes.clear();
      _refrences.clear();
      Function _eq = const DeepCollectionEquality.unordered().equals;
      _cartItems.forEach((item) {
        counter = item.quantity;
        string = '"' + item.note + '"';
        _orderProductList.add(item.product.id);
        _quantity.add(counter);
        _notes.add(string);
        _refrences.add(item.refrence);
        if (item.children.isNotEmpty) {
          item.children.forEach((p) {
            string = '"' + p.note + '"';
            _refrences.add(p.refrence);
            _notes.add(string);
            _orderProductList.add(p.product.id);
            var q = _cartItems
                .where((c) => _eq(c.children, item.children))
                .first
                .quantity;
            _quantity.add(q);
          });
        }
      });

      _loading = false;
      notifyListeners();
    }
  }

  calculateTax({double totalCart, double taxOne, double taxTwo}) {
    final total = totalCart;
    double tax = (total * (taxOne + taxTwo));
    return tax;
  }

  void cartIdPlus() {
    _cartId++;
    notifyListeners();
  }
}
