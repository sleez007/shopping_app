import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/routes/CartRoute.dart';
import 'package:shopping_app/widgets/AppDrawer.dart';
import 'package:shopping_app/widgets/ProductsGrid.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/badge.dart';


enum FilterOptions{
  FAVORITES,
  ALL
}
class ProductOverviewRoute extends StatefulWidget {
  @override
  ProductOverviewState createState() => ProductOverviewState();
}

class ProductOverviewState extends State<ProductOverviewRoute>{
  var _showOnlyFavorities = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("My Shop"),actions: <Widget>[
          Consumer<Cart>(
            builder: (context,cart,ch)=>Badge(child: ch, value :cart.itemCount.toString()),
            child: IconButton(icon: Icon(Icons.shopping_cart),onPressed: (){
              Navigator.of(context).pushNamed(CartRoute.routeName);
            },),
          ),

          PopupMenuButton(icon: Icon(Icons.more_vert), itemBuilder:(BuildContext _)=>[
            PopupMenuItem(child: Text('Only Favorites'),value: FilterOptions.FAVORITES),
            PopupMenuItem(child: Text('Show All'),value: FilterOptions.ALL),
          ],
            onSelected: (FilterOptions selected){
            setState(() {
              if(selected == FilterOptions.FAVORITES){
                _showOnlyFavorities = true;
              }else{
                _showOnlyFavorities = false;
              }
            });
            },
          )
        ],),
        drawer: AppDrawer(),
        body: ProductsGrid(_showOnlyFavorities)
    );
  }
}
