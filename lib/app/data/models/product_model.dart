import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String>? images;
  final int stock;
  final String brand;
  final String category;
  final List<String> features;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool featured;
  final bool onSale;
  final double? salePrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.images,
    required this.stock,
    required this.brand,
    required this.category,
    required this.features,
    required this.sizes,
    required this.colors,
    required this.rating,
    required this.reviewCount,
    this.featured = false,
    this.onSale = false,
    this.salePrice,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Product object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'stock': stock,
      'brand': brand,
      'category': category,
      'features': features,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'reviewCount': reviewCount,
      'featured': featured,
      'onSale': onSale,
      'salePrice': salePrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create Product object from a Map
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      stock: map['stock'] ?? 0,
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      features: List<String>.from(map['features'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      featured: map['featured'] ?? false,
      onSale: map['onSale'] ?? false,
      salePrice: (map['salePrice'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create a copy of Product with some updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? images,
    int? stock,
    String? brand,
    String? category,
    List<String>? features,
    List<String>? sizes,
    List<String>? colors,
    double? rating,
    int? reviewCount,
    bool? featured,
    bool? onSale,
    double? salePrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      features: features ?? this.features,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      featured: featured ?? this.featured,
      onSale: onSale ?? this.onSale,
      salePrice: salePrice ?? this.salePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 