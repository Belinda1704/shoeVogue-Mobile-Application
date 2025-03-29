import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

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
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadCart();
    debugPrint('CartController initialized with ${cartItems.length} items');
  }

  // Load cart items from local storage
  void loadCart() {
    final savedCart = storage.read<List>('cart');
    if (savedCart != null) {
      cartItems.value = savedCart.map((item) => Map<String, dynamic>.from(item)).toList();
      calculateTotals();
    }
  }

  // Save cart items to local storage
  void saveCart() {
    storage.write('cart', cartItems.toList());
  }

  // Calculate total price of all items in cart
  void calculateTotals() {
    double sum = 0;
    for (var item in cartItems) {
      sum += (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
    }
    total.value = sum;
  }

  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    // Deep copy the product to avoid reference issues
    final productCopy = Map<String, dynamic>.from(product);
    
    debugPrint('Adding to cart: ${productCopy['name']} (ID: ${productCopy['id']})');
    
    // Check if this product is already in the cart
    final existingIndex = cartItems.indexWhere((item) => item['id'] == productCopy['id']);
    
    if (existingIndex >= 0) {
      // If it exists, update quantity
      cartItems[existingIndex]['quantity'] = (cartItems[existingIndex]['quantity'] ?? 1) + quantity;
      // Update the price to reflect the new quantity
      cartItems[existingIndex]['totalPrice'] = 
          (cartItems[existingIndex]['price'] ?? 0.0) * cartItems[existingIndex]['quantity'];
      
      debugPrint('Updated quantity for existing product in cart: ${cartItems[existingIndex]['name']}');
    } else {
      // Add quantity and totalPrice to the product
      productCopy['quantity'] = quantity;
      productCopy['totalPrice'] = (productCopy['price'] ?? 0.0) * quantity;
      cartItems.add(productCopy);
      
      debugPrint('Added new product to cart: ${productCopy['name']}');
    }
    
    calculateTotals();
    saveCart();
    
    // Use debugPrint for debugging info
    debugPrint('Cart now contains ${cartItems.length} items:');
    for (var item in cartItems) {
      debugPrint('- ${item['name']} (Qty: ${item['quantity']})');
    }
  }

  void removeFromCart(String id, double? size) {
    cartItems.removeWhere((item) => 
      item['id'].toString() == id && 
      (item['size'] ?? 0.0) == (size ?? 0.0));
    cartItems.refresh();
    calculateTotals();
    saveCart();
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
        calculateTotals();
        saveCart();
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    calculateTotals();
    saveCart();
  }

  Future<void> checkout() async {
    // TODO: Implement checkout logic
    await Future.delayed(const Duration(seconds: 2)); // Simulated API call
    Get.toNamed('/checkout');
  }
} 