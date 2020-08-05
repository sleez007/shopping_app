import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/Orders.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/routes/CartRoute.dart';
import 'package:shopping_app/routes/EditProductRoute.dart';
import 'package:shopping_app/routes/OrdersRoute.dart';
import 'package:shopping_app/routes/ProductDetailRoute.dart';
import 'package:shopping_app/routes/ProductOverviewRoute.dart';
import 'package:shopping_app/routes/UserProductRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ChangeNotifierProvider(create: (_) => Cart() ),
      ChangeNotifierProvider(create:(_)=>Orders())
    ],
      child:MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              accentColor: Colors.deepOrange,
              primarySwatch: Colors.purple,
              fontFamily: 'Lato'

          ),

          routes: {
            '/': (_)=> ProductOverviewRoute(),
            ProductDetailRoute.routeName : (context)=>ProductDetailRoute(),
            CartRoute.routeName : (_)=> CartRoute(),
            OrdersRoute.routeName : (_)=> OrdersRoute(),
            UserProductRoute.routeName:(_)=>UserProductRoute(),
            EditProductRoute.routeName:(_)=>EditProductRoute()
          }

      ) ,
    );

  }
}

//ChangeNotifierProvider(
//create:(context)=> ProductsProvider(),
//return ChangeNotifierProvider.value(
// value: ProductsProvider(),
//child:
//);

