import 'package:flutter/material.dart';

class ProductService {
  List<Map<String, dynamic>> getProducts() {
    // Return a list of product maps instead of objects
    return [
      {
        'id': 1,
        'name': 'Nike Air Max',
        'price': 129.99,
        'description': 'Classic Nike Air Max shoes with air cushioning.',
        'category': 'Running',
        'imageUrl': 'assets/images/products/nike_air_max.png',
      },
      {
        'id': 2,
        'name': 'Adidas Ultraboost',
        'price': 149.99,
        'description': 'Adidas Ultraboost with responsive cushioning.',
        'category': 'Running',
        'imageUrl': 'assets/images/products/adidas_ultraboost.png',
      },
      // Add more product maps here...
    ];
  }

  // Other methods...
} 