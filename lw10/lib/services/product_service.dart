import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductException implements Exception {
  final String message;
  const ProductException(this.message);

  @override
  String toString() => message;
}

class ProductService {
  static const _url = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: const {
          'Accept': 'application/json',
          // некоторые серверы режут запросы без User-Agent
          'User-Agent': 'Mozilla/5.0 (PawTime Flutter App)',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw const ProductException('Products not found (404).');
      } else if (response.statusCode >= 500) {
        throw ProductException(
            'Server error (${response.statusCode}). Please try again later.');
      } else {
        throw ProductException(
            'Unexpected response (${response.statusCode}).');
      }
    } on TimeoutException {
      throw const ProductException(
          'The request timed out after 10 seconds. Check your connection.');
    } on SocketException {
      throw const ProductException(
          'No internet connection. Check your network and try again.');
    } on http.ClientException {
      throw const ProductException(
          'Network error. Check your connection and try again.');
    } on FormatException {
      throw const ProductException('Received invalid data from the server.');
    } on TypeError {
      throw const ProductException('Unexpected data format from the server.');
    }
  }
}