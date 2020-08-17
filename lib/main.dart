import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helper/CustomRoute.dart';
import 'package:shopping_app/providers/Auth.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/Orders.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/routes/AuthRoute.dart';
import 'package:shopping_app/routes/CartRoute.dart';
import 'package:shopping_app/routes/EditProductRoute.dart';
import 'package:shopping_app/routes/OrdersRoute.dart';
import 'package:shopping_app/routes/ProductDetailRoute.dart';
import 'package:shopping_app/routes/ProductOverviewRoute.dart';
import 'package:shopping_app/routes/SplashRoute.dart';
import 'package:shopping_app/routes/UserProductRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create:(_)=>Auth() ),
      ChangeNotifierProxyProvider<Auth,ProductsProvider>(update : (ctx,auth, previousProduct)=> ProductsProvider(auth.token, previousProduct==null ?[]: previousProduct.items, auth.userId)),
      ChangeNotifierProvider(create: (_) => Cart() ),
      ChangeNotifierProxyProvider<Auth,Orders>(update:(ctx,auth, previousOrders)=>Orders(auth.token,previousOrders == null ?[]: previousOrders.orders, auth.userId)),

    ],
      child:Consumer<Auth>(builder: (ctx, auth, _)=>
          MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                  accentColor: Colors.deepOrange,
                  primarySwatch: Colors.purple,
                  fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android : CustomPageTransitionsBuilder(),
                    TargetPlatform.iOS:CustomPageTransitionsBuilder()
                  }
                )

              ),

              routes: {
                '/': (_)=> auth.isAuth ? ProductOverviewRoute() :FutureBuilder(future: auth.tryAutoLogin(), builder: (ctx, snapShot)=>snapShot.connectionState ==ConnectionState.waiting ? SplashRoute() : AuthScreen(),),
                ProductDetailRoute.routeName : (context)=>ProductDetailRoute(),
                CartRoute.routeName : (_)=> CartRoute(),
                OrdersRoute.routeName : (_)=> OrdersRoute(),
                UserProductRoute.routeName:(_)=>UserProductRoute(),
                EditProductRoute.routeName:(_)=>EditProductRoute(),
                AuthScreen.routeName:(_)=>AuthScreen()
              }

          ) )
    );

  }
}

//ChangeNotifierProvider(
//create:(context)=> ProductsProvider(),
//return ChangeNotifierProvider.value(
// value: ProductsProvider(),
//child:
//);

