import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart';


class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin:EdgeInsets.symmetric(vertical: 4, horizontal: 15) ,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dismissDirection){
        return showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text('Are you sure'),
          content: Text('Do you want to remove the item from the cart?'),
          actions: <Widget>[
            FlatButton(child: Text('No'),onPressed: ()=>Navigator.of(context).pop(false),),
            FlatButton(child: Text('Yes'),onPressed: ()=>Navigator.of(context).pop(true),)
          ],
        ));
      },
      onDismissed: (direction){
         Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(child:FittedBox(child:Text('\$$price')),padding: EdgeInsets.all(5),),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
