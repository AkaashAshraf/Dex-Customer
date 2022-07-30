import 'package:customers/models/product.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/widgets/shop/provider_products_list_card.dart';
import 'package:flutter/material.dart';

class ProviderMenu extends StatelessWidget {
  final List<Product> products;
  final Shop shop;
  ProviderMenu({this.products, this.shop});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => ProviderProductsListCard(
        product: products[index],
        shop: shop,
      ),
      itemCount: products.length,
    );
  }
}
