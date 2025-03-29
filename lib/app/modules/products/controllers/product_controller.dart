import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../services/firestore_service.dart';

class ProductController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedProduct = Rxn<Product>();

  @override
  void onInit() {
    super.onInit();
    _subscribeToProducts();
  }

  // Subscribe to products stream
  void _subscribeToProducts() {
    _firestoreService.getProducts().listen(
      (productList) {
        products.value = productList;
      },
      onError: (error) {
        errorMessage.value = 'Error loading products: $error';
      },
    );
  }

  // Create a new product
  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required int stock,
    required String brand,
    required String category,
    required List<String> features,
    required List<String> sizes,
    required List<String> colors,
    required double rating,
    required int reviewCount,
    List<String>? images,
    bool featured = false,
    bool onSale = false,
    double? salePrice,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final product = Product(
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        stock: stock,
        brand: brand,
        category: category,
        features: features,
        sizes: sizes,
        colors: colors,
        rating: rating,
        reviewCount: reviewCount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final productId = await _firestoreService.createProduct(product);
      
      if (productId == null) {
        errorMessage.value = 'Failed to create product';
      }
    } catch (e) {
      errorMessage.value = 'Error creating product: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Get a single product
  Future<void> getProduct(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final product = await _firestoreService.getProduct(id);
      selectedProduct.value = product;

      if (product == null) {
        errorMessage.value = 'Product not found';
      }
    } catch (e) {
      errorMessage.value = 'Error getting product: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update a product
  Future<void> updateProduct(String id, {
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? stock,
    String? brand,
    String? category,
    List<String>? features,
    List<String>? sizes,
    List<String>? colors,
    double? rating,
    int? reviewCount,
    List<String>? images,
    bool? featured,
    bool? onSale,
    double? salePrice,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentProduct = selectedProduct.value;
      if (currentProduct == null) {
        errorMessage.value = 'No product selected';
        return;
      }

      final updatedProduct = currentProduct.copyWith(
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        stock: stock,
        brand: brand,
        category: category,
        features: features,
        sizes: sizes,
        colors: colors,
        rating: rating,
        reviewCount: reviewCount,
        images: images,
        featured: featured,
        onSale: onSale,
        salePrice: salePrice,
        updatedAt: DateTime.now(),
      );

      final success = await _firestoreService.updateProduct(id, updatedProduct);
      
      if (!success) {
        errorMessage.value = 'Failed to update product';
      }
    } catch (e) {
      errorMessage.value = 'Error updating product: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _firestoreService.deleteProduct(id);
      
      if (!success) {
        errorMessage.value = 'Failed to delete product';
      }
    } catch (e) {
      errorMessage.value = 'Error deleting product: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Search products
  Stream<List<Product>> searchProducts(String searchTerm) {
    return _firestoreService.searchProducts(searchTerm);
  }
} 