import 'package:flutter/material.dart';
import 'package:shopping_app/models/HttpException.dart';
import 'package:shopping_app/providers/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  final String authToken ;
  final String userId;

  ProductsProvider(this.authToken, this._items, this.userId);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((prod) => prod.id == id);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';
    final url = 'https://my-flutter-ecommerce.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(extractedData == null) return;
      //print(extractedData);
      final favoriteResponse = await http.get('https://my-flutter-ecommerce.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, productData) {
        print('${productData["title"]} is nkkknkn man $userId');
        loadedProducts.add(Product(
            id: prodId,
            title: productData['title'],
            description: productData['description'],
            price:productData['price'].toDouble(),
            isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false ,
            imageUrl: productData['imageUrl']));
      });
      _items = loadedProducts;
      print(_items);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://my-flutter-ecommerce.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId':userId
          }));
      print(response);
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        final url = 'https://my-flutter-ecommerce.firebaseio.com/products/$id.json?auth=$authToken';
        await http.patch(url, body: json.encode({'title': newProduct.title, 'description': newProduct.description, 'price': newProduct.price, 'imageUrl': newProduct.imageUrl}));
        _items[prodIndex] = newProduct;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://my-flutter-ecommerce.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod)=> prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
   final response = await http.delete(url);
    if(response.statusCode >= 400){
      print(response.statusCode);
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    existingProduct = null;

  }
}
