import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

// Rename the class to avoid conflicts with Flutter's SearchController
class ProductSearchController extends GetxController {
  final homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with all products instead of empty results
    searchResults.value = homeController.products;
  }
  
  void searchProducts(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    // Convert to lowercase for case-insensitive search
    final lowerCaseQuery = query.toLowerCase();
    
    // Debug with debugPrint instead of print
    debugPrint('Search query: "$query"');
    debugPrint('Total products: ${homeController.products.length}');

    searchResults.clear();
    
    if (lowerCaseQuery.isEmpty) {
      searchResults.assignAll(homeController.products);
      debugPrint('Showing all ${searchResults.length} products');
      return;
    }

    // Filter products based on name or category match
    for (final product in homeController.products) {
      final name = (product['name'] as String).toLowerCase();
      final category = (product['category'] as String).toLowerCase();
      
      final matchesName = name.contains(lowerCaseQuery);
      final matchesCategory = category.contains(lowerCaseQuery);
      
      // Debug with debugPrint
      debugPrint('Product: ${product['name']} - Matches name: $matchesName, Matches category: $matchesCategory');
      
      if (matchesName || matchesCategory) {
        searchResults.add(product);
      }
    }
    
    debugPrint('Found ${searchResults.length} matching products');
  }
  
  void toggleFavorite(String id) {
    homeController.toggleFavorite(id);
    // Refresh search results
    final currentQuery = searchController.text;
    searchProducts(currentQuery);
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
} 