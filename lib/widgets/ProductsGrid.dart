import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Product.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/widgets/ProductItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorities ;

  ProductsGrid(this.showOnlyFavorities);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final List<Product> products = showOnlyFavorities? productData.favoriteItems: productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder:(context,index)=>ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ) ,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/2, crossAxisSpacing: 10, mainAxisSpacing: 10),
    );
  }
}
