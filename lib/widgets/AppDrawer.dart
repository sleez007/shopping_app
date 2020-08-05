import 'package:flutter/material.dart';
import 'package:shopping_app/routes/OrdersRoute.dart';
import 'package:shopping_app/routes/UserProductRoute.dart';

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
          Navigator.of(context).pushReplacementNamed(OrdersRoute.routeName);
        },),
        Divider(),
        ListTile(leading: Icon(Icons.edit), title: Text('Manage products'), onTap: (){
          Navigator.of(context).pushReplacementNamed(UserProductRoute.routeName);
        },)
      ],),
    );
  }
}
