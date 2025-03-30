import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../../../services/firestore_service.dart';
import '../../../data/models/category_model.dart';

class CategoryController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  // Observable variables
  final _categories = <CategoryModel>[].obs;
  final _isLoading = true.obs;
  
  // Stream subscription
  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;
  
  // Getters
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }
  
  @override
  void onClose() {
    _categoriesSubscription?.cancel();
    super.onClose();
  }
  
  // Load categories from Firestore
  void _loadCategories() {
    try {
      _isLoading.value = true;
      
      _categoriesSubscription = _firestoreService.getCategories().listen(
        (categoryList) {
          _categories.value = categoryList;
          _isLoading.value = false;
        },
        onError: (error) {
          debugPrint('Error loading categories: $error');
          _isLoading.value = false;
        }
      );
    } catch (e) {
      debugPrint('Error subscribing to categories: $e');
      _isLoading.value = false;
    }
  }
  
  // Add a new category
  Future<bool> addCategory(CategoryModel category) async {
    try {
      final categoryId = await _firestoreService.createCategory(category);
      return categoryId != null;
    } catch (e) {
      debugPrint('Error adding category: $e');
      return false;
    }
  }
  
  // Update an existing category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      if (category.id == null) {
        debugPrint('Cannot update category without ID');
        return false;
      }
      
      return await _firestoreService.updateCategory(category.id!, category);
    } catch (e) {
      debugPrint('Error updating category: $e');
      return false;
    }
  }
  
  // Delete a category
  Future<bool> deleteCategory(String id) async {
    try {
      return await _firestoreService.deleteCategory(id);
    } catch (e) {
      debugPrint('Error deleting category: $e');
      return false;
    }
  }
  
  // Get a category by name
  CategoryModel? getCategoryByName(String name) {
    try {
      return _categories.firstWhereOrNull((cat) => cat.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      debugPrint('Error getting category by name: $e');
      return null;
    }
  }
  
  // Get a list of category names
  List<String> getCategoryNames() {
    return _categories.map((category) => category.name).toList();
  }
  
  // Refresh categories
  void refreshCategories() {
    _loadCategories();
  }
} 