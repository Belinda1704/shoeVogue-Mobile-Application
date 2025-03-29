import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<FirebaseService> init() async {
    return this;
  }
  
  // User Profile Methods
  Future<void> createUserProfile(String userId, Map<String, dynamic> userData) async {
    try {
      // Create basic user profile
      await _firestore.collection('users').doc(userId).set({
        'name': userData['fullName'],
        'email': userData['email'],
        'phoneNumber': userData['phoneNumber'] ?? '',
        'profilePicture': '',
        'shippingAddress': {
          'address': '',
          'country': '',
          'zipCode': ''
        },
        'orderHistory': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create empty cart for the user
      await _firestore.collection('cart').doc(userId).set({
        'userId': userId,
        'items': [],
        'estimatedTotal': 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create user profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw e; // Rethrow to handle in the UI
    }
  }
  
  Future<DocumentSnapshot?> getUserProfile(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get user profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw e;
    }
  }

  // Cart Methods
  Future<void> addToCart(String userId, Map<String, dynamic> item) async {
    try {
      DocumentReference cartRef = _firestore.collection('cart').doc(userId);
      DocumentSnapshot cartDoc = await cartRef.get();

      if (!cartDoc.exists) {
        // Create new cart if it doesn't exist
        await cartRef.set({
          'userId': userId,
          'items': [item],
          'estimatedTotal': item['price'] * item['quantity'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing cart
        List<dynamic> items = List.from(cartDoc.get('items') ?? []);
        items.add(item);
        double total = items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
        
        await cartRef.update({
          'items': items,
          'estimatedTotal': total,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw e;
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      DocumentReference cartRef = _firestore.collection('cart').doc(userId);
      DocumentSnapshot cartDoc = await cartRef.get();

      if (cartDoc.exists) {
        List<dynamic> items = List.from(cartDoc.get('items') ?? []);
        items.removeWhere((item) => item['productId'] == productId);
        double total = items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

        await cartRef.update({
          'items': items,
          'estimatedTotal': total,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw e;
    }
  }

  // Order Methods
  Future<void> createOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      // Create the order
      DocumentReference orderRef = await _firestore.collection('orders').add({
        'userId': userId,
        'items': orderData['items'],
        'totalPrice': orderData['totalPrice'],
        'paymentStatus': 'Pending',
        'orderStatus': 'Processing',
        'shippingAddress': orderData['shippingAddress'],
        'orderDate': FieldValue.serverTimestamp(),
      });

      // Update user's order history
      await _firestore.collection('users').doc(userId).update({
        'orderHistory': FieldValue.arrayUnion([orderRef.id]),
      });

      // Clear the user's cart
      await _firestore.collection('cart').doc(userId).update({
        'items': [],
        'estimatedTotal': 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw e;
    }
  }

  // Product Methods
  Stream<QuerySnapshot> getProducts({String? category}) {
    Query query = _firestore.collection('products');
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots();
  }

  Future<DocumentSnapshot?> getProduct(String productId) async {
    try {
      return await _firestore.collection('products').doc(productId).get();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Category Methods
  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('categories').snapshots();
  }
} 