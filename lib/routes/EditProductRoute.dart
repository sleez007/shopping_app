import 'package:flutter/material.dart';
import 'package:shopping_app/providers/Product.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/ProductsProvider.dart';

class EditProductRoute extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductRouteState createState() => _EditProductRouteState();
}

class _EditProductRouteState extends State<EditProductRoute> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _isLoading = false;
  var _isInit = true;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    setState(() {
      _isLoading = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();

        try{
          if (_editedProduct.id != null) {
            await  Provider.of<ProductsProvider>(context, listen: false)
                .updateProduct(_editedProduct.id, _editedProduct);

          }else{
            await Provider.of<ProductsProvider>(context, listen: false)
                .addProduct(_editedProduct);
          }
        }catch(error){
          print('oops.....');
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error occurred'),
              content: Text("Something went wrong"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        }finally{
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }

    }else{
      print('form is invalid');
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        final product =
            Provider.of<ProductsProvider>(context, listen: false).findById(id);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl':_editedProduct.imageUrl
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  autovalidate: true,
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          return (value.trim().isEmpty)
                              ? 'Please provide a value'
                              : null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          return (value.isEmpty)
                              ? 'Please enter a valid number'
                              : (double.tryParse(value) == null)
                                  ? 'Please enter a valid number'
                                  : (double.parse(value) <= 0)
                                      ? 'Please enter a number greater than zero'
                                      : null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          return (value.trim().isEmpty)
                              ? 'Please provide a description'
                              : (value.trim().length < 10)
                                  ? 'Minimum of 10 characters'
                                  : null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: value,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm,
                              validator: (value) {
                                return (value.trim().isEmpty)
                                    ? 'Please provide an image url'
                                    : (!value.startsWith('http') ||
                                            !value.startsWith('https'))
                                        ? 'Please enter a valid url'
                                        : null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    description: _editedProduct.description,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
