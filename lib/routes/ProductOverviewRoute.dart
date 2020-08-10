import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/routes/CartRoute.dart';
import 'package:shopping_app/widgets/AppDrawer.dart';
import 'package:shopping_app/widgets/ProductsGrid.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/badge.dart';

enum FilterOptions { FAVORITES, ALL }

class ProductOverviewRoute extends StatefulWidget {
  @override
  ProductOverviewState createState() => ProductOverviewState();
}

class ProductOverviewState extends State<ProductOverviewRoute> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .catchError((error)=>{})
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Shop"),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (context, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartRoute.routeName);
                },
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext _) => [
                PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.FAVORITES),
                PopupMenuItem(
                    child: Text('Show All'), value: FilterOptions.ALL),
              ],
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.FAVORITES) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showOnlyFavorites));
  }
}
