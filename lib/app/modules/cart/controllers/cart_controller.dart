import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

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
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'totalPrice': price * quantity,
    };
  }
  
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }
}

class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();
  
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();
  
  // Make sure this is initialized properly
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  final storage = GetStorage();
  final RxBool isLoading = false.obs;

  final RxDouble _subtotal = 0.0.obs;
  final RxDouble _shippingCost = 5.99.obs; // Default shipping cost

  // Getters for cart totals
  double get subtotal => _subtotal.value;
  double get shippingCost => _shippingCost.value;
  double get total => _subtotal.value + _shippingCost.value;

  String? get _userId => _authService.currentUser.value?.uid;
  bool get isUserLoggedIn => _userId != null;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    debugPrint('CartController initialized with ${cartItems.length} items');
  }

  // Load cart items from Firestore if user is logged in, otherwise from local storage
  Future<void> loadCart() async {
    isLoading.value = true;
    
    if (isUserLoggedIn) {
      try {
        // Load from Firestore
        final items = await _firestoreService.getUserCartItems(_userId!);
        if (items.isNotEmpty) {
          cartItems.value = items;
          calculateTotals();
          debugPrint('Loaded ${items.length} cart items from Firestore');
        } else {
          // If Firestore cart is empty, try loading from local storage
          _loadFromLocalStorage();
          // If we had items in local storage, save them to Firestore
          if (cartItems.isNotEmpty) {
            _syncLocalToFirestore();
          }
        }
      } catch (e) {
        debugPrint('Error loading cart from Firestore: $e');
        _loadFromLocalStorage();
      }
    } else {
      // User not logged in, load from local storage
      _loadFromLocalStorage();
    }
    
    isLoading.value = false;
  }
  
  // Helper to load from local storage
  void _loadFromLocalStorage() {
    final savedCart = storage.read<List>('cart');
    if (savedCart != null) {
      cartItems.value = savedCart.map((item) => Map<String, dynamic>.from(item)).toList();
      calculateTotals();
      debugPrint('Loaded ${cartItems.length} cart items from local storage');
    }
  }
  
  // Sync local cart to Firestore
  Future<void> _syncLocalToFirestore() async {
    if (!isUserLoggedIn || cartItems.isEmpty) return;
    
    try {
      for (var item in cartItems) {
        await _firestoreService.addToCart(_userId!, item);
      }
      debugPrint('Synced ${cartItems.length} items from local storage to Firestore');
    } catch (e) {
      debugPrint('Error syncing local cart to Firestore: $e');
    }
  }

  // Save cart items to Firestore and local storage
  Future<void> saveCart() async {
    // Always save to local storage as a backup
    storage.write('cart', cartItems.toList());
    
    // If user is logged in, save to Firestore as well
    if (isUserLoggedIn) {
      try {
        // Clear existing cart first
        await _firestoreService.clearCart(_userId!);
        
        // Add all items
        for (var item in cartItems) {
          await _firestoreService.addToCart(_userId!, item);
        }
        debugPrint('Saved ${cartItems.length} cart items to Firestore');
      } catch (e) {
        debugPrint('Error saving cart to Firestore: $e');
      }
    }
  }

  // Calculate total price of all items in cart
  void calculateTotals() {
    double sum = 0;
    for (var item in cartItems) {
      sum += (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
    }
    _subtotal.value = sum;
  }

  Future<void> addToCart(Map<String, dynamic> product, {int quantity = 1}) async {
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
    await saveCart();
    
    // Show feedback to user
    Get.snackbar(
      'Added to Cart',
      '${productCopy['name']} added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    // Use debugPrint for debugging info
    debugPrint('Cart now contains ${cartItems.length} items:');
    for (var item in cartItems) {
      debugPrint('- ${item['name']} (Qty: ${item['quantity']})');
    }
  }

  Future<void> removeFromCart(String id, double? size) async {
    cartItems.removeWhere((item) => 
      item['id'].toString() == id && 
      (item['size'] ?? 0.0) == (size ?? 0.0));
    cartItems.refresh();
    calculateTotals();
    await saveCart();
  }

  Future<void> updateQuantity(String id, double? size, int quantity) async {
    final index = cartItems.indexWhere((item) => 
      item['id'].toString() == id && 
      (item['size'] ?? 0.0) == (size ?? 0.0));

    if (index != -1) {
      if (quantity <= 0) {
        await removeFromCart(id, size);
      } else {
        cartItems[index]['quantity'] = quantity;
        cartItems.refresh();
        calculateTotals();
        await saveCart();
      }
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    calculateTotals();
    await saveCart();
    
    // If user is logged in, clear cart in Firestore too
    if (isUserLoggedIn) {
      try {
        await _firestoreService.clearCart(_userId!);
        debugPrint('Cleared cart in Firestore');
      } catch (e) {
        debugPrint('Error clearing cart in Firestore: $e');
      }
    }
  }

  Future<void> checkout() async {
    // TODO: Implement checkout logic
    await Future.delayed(const Duration(seconds: 2)); // Simulated API call
    Get.toNamed('/checkout');
  }

  // Decrease quantity of an item at specific index
  void decreaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index]['quantity'] ?? 1;
      if (currentQty > 1) {
        cartItems[index]['quantity'] = currentQty - 1;
        cartItems.refresh();
        calculateTotals();
        saveCart();
      } else {
        // Remove item if quantity would be zero
        final id = cartItems[index]['id']?.toString() ?? '';
        final size = cartItems[index]['size'];
        removeFromCart(id, size);
      }
    }
  }

  // Increase quantity of an item at specific index
  void increaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index]['quantity'] ?? 1;
      // Optionally add a maximum quantity check if needed
      cartItems[index]['quantity'] = currentQty + 1;
      cartItems.refresh();
      calculateTotals();
      saveCart();
    }
  }
} 