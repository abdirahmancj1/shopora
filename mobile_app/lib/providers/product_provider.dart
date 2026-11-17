import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    print("ProductProvider: Fetching products...");
    try {
      final response = await _apiService.get(ApiConstants.products);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['results'] as List?;
        if (data != null) {
          _products = data.map((item) => Product.fromJson(item)).toList();
          print("ProductProvider: Loaded ${_products.length} products");
        }
      }
    } catch (e) {
      print("ProductProvider Error (fetchProducts): $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categories);
      if (response.statusCode == 200) {
        _categories = (response.data['results'] as List)
            .map((item) => Category.fromJson(item))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
  
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiService.get(ApiConstants.search, queryParameters: {'q': query});
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => Product.fromJson(item))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
