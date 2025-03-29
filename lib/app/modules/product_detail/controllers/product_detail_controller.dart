import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailController extends GetxController {
  final RxMap<String, dynamic> product = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool isFavorite = false.obs;
  final RxDouble selectedSize = 8.5.obs;
  
  final homeController = Get.find<HomeController>();
  final cartController = Get.find<CartController>();
  
  @override
  void onInit() {
    super.onInit();
    // Get product data from arguments
    loadProduct();
  }
  
  void loadProduct() {
    try {
      final productData = Get.arguments as Map<String, dynamic>;
      product.assignAll(productData);
      isFavorite.value = productData['isFavorite'] ?? false;
      isLoading.value = false;
    } catch (e) {
      Get.log('Error loading product: $e');
      isLoading.value = false;
    }
  }
  
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    product['isFavorite'] = isFavorite.value;
    
    // Update product in the home controller
    homeController.toggleFavorite(product['id']);
  }
  
  void selectSize(double size) {
    selectedSize.value = size;
  }
  
  void addToCart() {
    // Get the cart controller
    final cartController = Get.find<CartController>();
    
    // Add the product to cart with selected size
    cartController.addToCart(product.toJson(), size: selectedSize.value);
  }
} 