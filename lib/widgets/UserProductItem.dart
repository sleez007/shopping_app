import 'package:flutter/material.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';
import 'package:shopping_app/routes/EditProductRoute.dart';
import 'package:provider/provider.dart';
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:Text(title) ,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), onPressed: (){
              Navigator.of(context).pushNamed(EditProductRoute.routeName, arguments:id );
            },color: Theme.of(context).primaryColor),
            IconButton(icon: Icon(Icons.delete), onPressed: (){
              Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
            }, color: Theme.of(context).errorColor,)
          ],
        ),
      )
    );
  }
}