import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Orders.dart' show Orders;
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/AppDrawer.dart';
import 'package:shopping_app/widgets/OrderItem.dart';

class OrdersRoute extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
   // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot){
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            if(dataSnapshot.error!=null){
              return Center(child: Text('An Error occured!'));
            }else{
              return Consumer<Orders>(builder: (ctx, ordersData, child)=>ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (_, i) => OrderItem(ordersData.orders[i])));
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

//class _OrdersRouteState extends State<OrdersRoute> {
//  var _isLoading = false;
//  @override
//  void initState() {
//    super.initState();
//    //Future.delayed(Duration.zero).then((_) async{
////    _isLoading = true;
////    Provider.of<Orders>(context, listen: false)
////        .fetchAndSetOrders()
////        .then((_) => setState(() {
////              _isLoading = false;
////            }));
////    ;
//    // });
//  }
//
//
//}
