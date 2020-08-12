import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/routes/EditProductRoute.dart';
import 'package:shopping_app/widgets/AppDrawer.dart';
import 'package:shopping_app/widgets/UserProductItem.dart';

class UserProductRoute extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductRoute.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot)=>snapshot.connectionState == ConnectionState.waiting?Center(child: CircularProgressIndicator()): RefreshIndicator(
          onRefresh: ()=> _refreshProducts(context),
          child:Consumer<ProductsProvider>(
            builder: (ctx, productData,_)=>Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (_, index) => Column(
                    children: <Widget>[
                      UserProductItem(
                          title: productData.items[index].title,
                          imageUrl: productData.items[index].imageUrl,
                          id: productData.items[index].id),
                      Divider()
                    ],
                  )),
            ),
          )
        ),
      )
    );
  }
}

//class _UserProductRouteState extends State<UserProductRoute> {
//
//
//}
