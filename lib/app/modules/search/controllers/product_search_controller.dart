import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductSearchController extends GetxController {
  final ProductService _productService = ProductService();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();
  final CartController _cartController = Get.find<CartController>();
  
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  String? get _userId => _authService.currentUser.value?.uid;
  bool get isUserLoggedIn => _userId != null;

  @override
  void onInit() {
    super.onInit();
    // Don't load all products initially to match screenshot behavior
    searchResults.clear();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    isLoading.value = true;
    
    // Get all products from service
    final allProducts = _productService.getProducts();
    
    if (query.isEmpty) {
      // If query is empty, clear results
      searchResults.clear();
    } else {
      // Filter products based on the query
      final queryLower = query.toLowerCase();
      
      searchResults.value = allProducts.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final description = (product['description'] ?? '').toString().toLowerCase();
        final category = (product['category'] ?? '').toString().toLowerCase();
        
        return name.contains(queryLower) || 
               description.contains(queryLower) || 
               category.contains(queryLower);
      }).toList();
      
      // Check favorite status for each product
      _syncFavoriteStatus();
      
      // Debug output
      debugPrint('Search query: "$query", Found ${searchResults.length} results');
    }
    
    isLoading.value = false;
  }
  
  // Sync favorite status from Firestore
  Future<void> _syncFavoriteStatus() async {
    if (!isUserLoggedIn || searchResults.isEmpty) return;
    
    try {
      // Get user document from Firestore
      final userDoc = await _firestoreService.getUser(_userId!);
      if (userDoc == null) return;
      
      // Get favorite product IDs
      final List<String> favoriteIds = List<String>.from(userDoc.favoriteProducts);
      
      // Update search results with favorite status
      for (int i = 0; i < searchResults.length; i++) {
        final product = Map<String, dynamic>.from(searchResults[i]);
        final String productId = product['id'].toString();
        
        // Set isFavorite based on whether the ID exists in favoriteIds
        product['isFavorite'] = favoriteIds.contains(productId);
        searchResults[i] = product;
      }
      
      // Refresh search results in UI
      searchResults.refresh();
    } catch (e) {
      debugPrint('Error syncing favorites for search results: $e');
    }
  }
  
  // Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    if (!isUserLoggedIn) {
      Get.snackbar(
        'Sign In Required',
        'Please sign in to save your favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      // Find the product in search results
      final index = searchResults.indexWhere((product) => product['id'].toString() == productId);
      if (index == -1) return;
      
      // Get the product and toggle favorite status
      final product = Map<String, dynamic>.from(searchResults[index]);
      final bool newFavoriteStatus = !(product['isFavorite'] ?? false);
      
      // Update local state
      product['isFavorite'] = newFavoriteStatus;
      searchResults[index] = product;
      searchResults.refresh();
      
      // Update in Firestore
      if (newFavoriteStatus) {
        await _firestoreService.addToFavorites(_userId!, productId);
        Get.snackbar(
          'Added to Favorites',
          '${product['name']} added to your favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _firestoreService.removeFromFavorites(_userId!, productId);
        Get.snackbar(
          'Removed from Favorites',
          '${product['name']} removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Could not update favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Add to cart
  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      await _cartController.addToCart(product);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Could not add to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 