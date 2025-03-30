import 'package:flutter/material.dart';

class ProductService {
  List<Map<String, dynamic>> getProducts() {
    // Return a list of product maps instead of objects
    return [
      {
        'id': 1,
        'name': 'Nike Air Jordan Orange',
        'price': 199.99,
        'description': 'Classic Nike Air Jordan Orange with air cushioning.',
        'category': 'Sneakers',
        'imageUrl': 'assets/images/products/product1.jpg',
      },
      {
        'id': 2,
        'name': 'Nike Air Jordan Blue',
        'price': 189.99,
        'description': 'Nike Air Jordan Blue with responsive cushioning.',
        'category': 'Sneakers',
        'imageUrl': 'assets/images/products/product2.jpg',
      },
      {
        'id': 3,
        'name': 'Nike Air Jordan Black',
        'price': 209.99,
        'description': 'Nike Air Jordan Black with modern design and comfort.',
        'category': 'Sneakers',
        'imageUrl': 'assets/images/products/product3.jpg',
      },
      {
        'id': 4,
        'name': 'Nike Air Jordan White',
        'price': 199.99,
        'description': 'Nike Air Jordan White with retro styling.',
        'category': 'Sneakers',
        'imageUrl': 'assets/images/products/product4.jpg',
      },
    ];
  }

  // Other methods...
} 