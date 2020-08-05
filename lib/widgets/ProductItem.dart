import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/Product.dart';
import 'package:shopping_app/routes/ProductDetailRoute.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget{
//  final String id, title, imageUrl;
//
//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
   final product = Provider.of<Product>(context, listen: false);
   final cart = Provider.of<Cart>(context, listen: false);
   print('Product rebuilds');
    return ClipRRect(
    borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(product.imageUrl, fit: BoxFit.cover,),
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailRoute.routeName, arguments: product.id);
          },
        ),
    footer: GridTileBar(
    backgroundColor: Colors.black87,
    title: Text(product.title, textAlign: TextAlign.center,),

    leading: Consumer<Product>(
      builder: (context, product, child)=>IconButton(icon: Icon(product.isFavorite ?Icons.favorite : Icons.favorite_border),color: Theme.of(context).accentColor,onPressed:product.toggleFavoriteStatus),
    ),

    trailing: IconButton(icon: Icon(Icons.shopping_cart),color: Theme.of(context).accentColor,onPressed: (){
      cart.addItem(product.id, product.price, product.title);
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Added item to cart"),duration: Duration(seconds: 2), action: SnackBarAction(label: 'Undo', onPressed: (){
        cart.removeSingleItem(product.id);
      }),));
      },),

    ),
    ));
  }

}