import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  double get total => price * quantity;
}

class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();
  
  // Make sure this is initialized properly
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotal();
    print('CartController initialized with ${cartItems.length} items');
  }

  void addToCart(Map<String, dynamic> product, {double? size}) {
    // Convert the product to a new Map to avoid reference issues
    final Map<String, dynamic> productCopy = Map<String, dynamic>.from(product);
    
    print('Adding to cart: ${productCopy['name']} (ID: ${productCopy['id']})');
    
    // Deep copy to avoid reference issues
    final String productId = productCopy['id'].toString();
    final double productSize = size ?? 0.0;
    
    // Check if product exists in cart
    final int existingIndex = cartItems.indexWhere((item) => 
        item['id'].toString() == productId && 
        (item['size'] ?? 0.0) == productSize);
    
    if (existingIndex >= 0) {
      // Update quantity of existing item
      cartItems[existingIndex]['quantity'] = (cartItems[existingIndex]['quantity'] ?? 0) + 1;
      print('Updated quantity for existing product in cart: ${cartItems[existingIndex]['name']}');
    } else {
      // Add as new item
      productCopy['quantity'] = 1;
      productCopy['size'] = productSize;
      cartItems.add(productCopy);
      print('Added new product to cart: ${productCopy['name']}');
    }
    
    // Force refresh
    cartItems.refresh();
    calculateTotal();
    
    // Print cart contents for debugging
    print('Cart now contains ${cartItems.length} items:');
    for (var item in cartItems) {
      print('- ${item['name']} (Qty: ${item['quantity']})');
    }
    
    // Show feedback
    Get.snackbar(
      'Added to Cart',
      '${productCopy['name']} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromCart(String id, double? size) {
    cartItems.removeWhere((item) => 
      item['id'].toString() == id && 
      (item['size'] ?? 0.0) == (size ?? 0.0));
    cartItems.refresh();
    calculateTotal();
  }

  void updateQuantity(String id, double? size, int quantity) {
    final index = cartItems.indexWhere((item) => 
      item['id'].toString() == id && 
      (item['size'] ?? 0.0) == (size ?? 0.0));

    if (index != -1) {
      if (quantity <= 0) {
        removeFromCart(id, size);
      } else {
        cartItems[index]['quantity'] = quantity;
        cartItems.refresh();
        calculateTotal();
      }
    }
  }

  void calculateTotal() {
    double sum = 0;
    for (var item in cartItems) {
      sum += (item['price'] * (item['quantity'] ?? 1));
    }
    total.value = sum;
  }

  void clearCart() {
    cartItems.clear();
    calculateTotal();
  }

  Future<void> checkout() async {
    // TODO: Implement checkout logic
    await Future.delayed(const Duration(seconds: 2)); // Simulated API call
    Get.toNamed('/checkout');
  }
} 