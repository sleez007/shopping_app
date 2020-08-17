import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';

class ProductDetailRoute extends StatelessWidget {

  static const routeName = '/product-detail';



  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    //final product = Provider.of<ProductsProvider>(context, listen: false).findById(id);
    //setting listen to false prevents updates when a change is made to the data
    final product = Provider.of<ProductsProvider>(context).findById(id);
    return Scaffold(
     // appBar: AppBar(title: Text(product.title),),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight:300 ,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover,)
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text('\$${product.price}',style: TextStyle(color: Colors.grey, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:  Text(product.description, textAlign: TextAlign.center,softWrap: true,),
                      ),
                      SizedBox(height: 800,)
                    ],
                  ),
                ]
              )
          )
        ],

      )

    );
  }
}
