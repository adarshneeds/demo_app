import 'dart:convert';

import 'package:demo/models/products_model.dart';
import 'package:demo/services/products_api_services.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  ProductModel? _productList;
  bool _isLoading = true;
  String? _error;

  ProductModel? get productList => _productList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool _isLoadMoreLoading = false;
  bool get isLoadMoreLoading => _isLoadMoreLoading;

  ProductsProvider() {
    _getProducts(skip: 0);
  }

  Future<void> _getProducts({required int skip}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ProductsApiServices.getProducts(skip);
      final data = jsonDecode(response.body);
      _productList = ProductModel.fromJson(data);
    } catch (e) {
      _error = '$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProduct({required String query}) async {
    try {
      _productList = null;
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ProductsApiServices.searchProducts(query);
      final data = jsonDecode(response.body);
      _productList = ProductModel.fromJson(data);
    } catch (e) {
      _error = '$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(int skip) async {
    try {
      _isLoadMoreLoading = true;
      notifyListeners();

      final response = await ProductsApiServices.getProducts(skip);
      final data = jsonDecode(response.body);
      final List<Product>? products =
          data['products'] != null ? List<Product>.from(data['products'].map((x) => Product.fromJson(x))) : null;
      final int? totalValue = data['total'];
      final int? skipValue = data['skip'];
      final int? limitValue = data['limit'];

      products?.forEach(
        (element) {
          _productList?.products?.add(element);
        },
      );

      _productList?.total = totalValue;
      _productList?.limit = limitValue;
      _productList?.skip = skipValue;
    } finally {
      _isLoadMoreLoading = false;
      notifyListeners();
    }
  }
}
