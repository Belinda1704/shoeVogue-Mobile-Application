import 'package:get/get.dart';
import '../../../data/services/product_service.dart';

class ProductSearchController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<dynamic> searchResults = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  void getAllProducts() {
    isLoading.value = true;
    searchResults.value = _productService.getProducts();
    isLoading.value = false;
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    isLoading.value = true;
    
    if (query.isEmpty) {
      searchResults.value = _productService.getProducts();
    } else {
      final queryLower = query.toLowerCase();
      final allProducts = _productService.getProducts();
      
      searchResults.value = allProducts.where((product) {
        try {
          // Safe string search that works for both maps and objects
          final searchText = _getSearchableText(product).toLowerCase();
          return searchText.contains(queryLower);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    isLoading.value = false;
  }
  
  // Helper method to extract searchable text from a product
  String _getSearchableText(dynamic product) {
    try {
      if (product is Map) {
        return [
          product['name'] ?? '',
          product['description'] ?? '',
          product['category'] ?? '',
        ].join(' ');
      } else {
        return [
          product.name ?? '',
          product.description ?? '',
          product.category ?? '',
        ].join(' ');
      }
    } catch (e) {
      return '';
    }
  }
} 