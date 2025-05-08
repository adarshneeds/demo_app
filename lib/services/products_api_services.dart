import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProductsApiServices {
  static Future<Response> getProducts(int skip) async {
    final request = http.get(Uri.parse('https://dummyjson.com/products?limit=30&skip=$skip'));
    return request;
  }

  static Future<Response> searchProducts(String query) async {
    final request = http.get(Uri.parse('https://dummyjson.com/products/search?q=$query'));
    return request;
  }
}
