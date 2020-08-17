import 'package:flutter/material.dart';
import 'package:shopping_app/helper/CustomRoute.dart';
import 'package:shopping_app/providers/Auth.dart';
import 'package:shopping_app/routes/OrdersRoute.dart';
import 'package:shopping_app/routes/UserProductRoute.dart';
import 'package:provider/provider.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(title: Text('Hello Friend!'), automaticallyImplyLeading:  false,),
        Divider(),
        ListTile(leading: Icon(Icons.shop), title: Text('Shop'), onTap: (){
          Navigator.of(context).pushReplacementNamed('/');
        },),
        Divider(),
        ListTile(leading: Icon(Icons.payment), title: Text('Orders'), onTap: (){
         // Navigator.of(context).pushReplacementNamed(OrdersRoute.routeName);
          Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>OrdersRoute()));
        },),
        Divider(),
        ListTile(leading: Icon(Icons.edit), title: Text('Manage products'), onTap: (){
          Navigator.of(context).pushReplacementNamed(UserProductRoute.routeName);
        },),
        Divider(),
        ListTile(leading: Icon(Icons.power_settings_new), title: Text('Logout'), onTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/');
          Provider.of<Auth>(context, listen: false).logout();
        },)
      ],),
    );
  }
}
