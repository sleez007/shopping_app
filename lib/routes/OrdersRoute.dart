import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Orders.dart' show Orders;
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/AppDrawer.dart';
import 'package:shopping_app/widgets/OrderItem.dart';

class OrdersRoute extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar:  AppBar(title: Text('Your Orders'),),
      body: ListView.builder(itemCount: ordersData.orders.length,itemBuilder: (_, i)=>OrderItem(ordersData.orders[i])),
      drawer: AppDrawer(),
    );
  }
}
