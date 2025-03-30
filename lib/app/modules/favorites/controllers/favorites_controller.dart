import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String brand;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.brand,
  });

  factory FavoriteItem.fromProduct(Product product) {
    return FavoriteItem(
      id: product.id ?? '',
      name: product.name,
      price: product.price,
      image: product.imageUrl,
      brand: product.brand,
    );
  }
  
  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? 'Unknown Product',
      price: (map['price'] ?? 0.0).toDouble(),
      image: map['imageUrl'] ?? 'assets/images/placeholder.png',
      brand: map['category'] ?? 'Unknown',
    );
  }
}

class FavoritesController extends GetxController {
  final _items = <FavoriteItem>[].obs;
  final _isLoading = false.obs;

  // Get services
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();
  final ProductService _productService = ProductService();

  // User ID
  String? get _userId => _authService.currentUser.value?.uid;
  bool get isUserLoggedIn => _userId != null;
  
  List<FavoriteItem> get items => _items;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    
    // Listen for auth changes to reload favorites when user signs in/out
    ever(_authService.currentUser, (_) => loadFavorites());
  }

  // Load favorites from Firestore
  Future<void> loadFavorites() async {
    try {
      _isLoading.value = true;
      
      if (!isUserLoggedIn) {
        debugPrint('No user signed in, clearing favorites');
        _items.clear();
        _isLoading.value = false;
        return;
      }
      
      debugPrint('Loading favorites for user: $_userId');
      
      // Get the user's favorite product IDs from Firestore
      final userDoc = await _firestoreService.getUser(_userId!);
      if (userDoc == null) {
        debugPrint('User document not found in Firestore');
        _items.clear();
        _isLoading.value = false;
        return;
      }
      
      final List<String> favoriteIds = List<String>.from(userDoc.favoriteProducts);
      debugPrint('Found ${favoriteIds.length} favorite IDs in Firestore');
      
      if (favoriteIds.isEmpty) {
        _items.clear();
        _isLoading.value = false;
        return;
      }
      
      // Get all products
      final allProducts = _productService.getProducts();
      
      // Filter products to get only favorites
      final List<Map<String, dynamic>> favoriteProducts = allProducts
          .where((product) => favoriteIds.contains(product['id'].toString()))
          .toList();
      
      // Convert to FavoriteItem objects
      _items.value = favoriteProducts
          .map((product) => FavoriteItem.fromMap(product))
          .toList();
      
      debugPrint('Loaded ${_items.length} favorite items');
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add an item to favorites (both local and Firestore)
  Future<void> addToFavorites(FavoriteItem item) async {
    try {
      // Check if user is signed in
      if (!isUserLoggedIn) {
        Get.snackbar(
          'Sign In Required',
          'Please sign in to add items to your favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // First update local state
      if (!_items.any((i) => i.id == item.id)) {
        _items.add(item);
      }
      
      // Then save to Firestore
      await _firestoreService.addToFavorites(_userId!, item.id);
      debugPrint('Added item ${item.id} to favorites in Firestore');
      
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      Get.snackbar(
        'Error',
        'Could not add item to favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove an item from favorites (both local and Firestore)
  Future<void> removeFromFavorites(String id) async {
    try {
      // Check if user is signed in
      if (!isUserLoggedIn) {
        Get.snackbar(
          'Sign In Required',
          'Please sign in to manage your favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // First update local state
      _items.removeWhere((item) => item.id == id);
      
      // Then save to Firestore
      await _firestoreService.removeFromFavorites(_userId!, id);
      debugPrint('Removed item $id from favorites in Firestore');
      
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      Get.snackbar(
        'Error',
        'Could not remove item from favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Check if an item is in favorites
  bool isFavorite(String id) {
    return _items.any((item) => item.id == id);
  }

  // Refresh favorites from Firestore
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  Future<void> addToCart(FavoriteItem item) async {
    _isLoading.value = true;
    
    // Convert FavoriteItem to a map compatible with CartController
    final Map<String, dynamic> productMap = {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'imageUrl': item.image,
      'category': item.brand,
    };
    
    try {
      // Get cart controller
      final cartController = Get.find<dynamic>();
      await cartController.addToCart(productMap);
      
      Get.snackbar(
        'Added to Cart',
        '${item.name} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Could not add to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
} 