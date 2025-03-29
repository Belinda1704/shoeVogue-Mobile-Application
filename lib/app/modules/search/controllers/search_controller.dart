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
    isLoading.value = true;
    
    // Print debug information
    print('Search query: "$query"');
    print('Total products: ${homeController.products.length}');
    
    if (query.isEmpty) {
      // If query is empty, show all products
      searchResults.value = homeController.products;
      print('Showing all ${searchResults.length} products');
    } else {
      // Filter products that contain the query in name or category (case insensitive)
      searchResults.value = homeController.products
          .where((product) {
            final name = product['name']?.toString().toLowerCase() ?? '';
            final category = product['category']?.toString().toLowerCase() ?? '';
            final searchLower = query.toLowerCase();
            
            final matchesName = name.contains(searchLower);
            final matchesCategory = category.contains(searchLower);
            
            print('Product: ${product['name']} - Matches name: $matchesName, Matches category: $matchesCategory');
            
            return matchesName || matchesCategory;
          })
          .toList();
      print('Found ${searchResults.length} matching products');
    }
    
    isLoading.value = false;
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