import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/models/user_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection names
  final String usersCollection = 'users';
  final String productsCollection = 'products';
  final String categoriesCollection = 'categories';
  final String brandsCollection = 'brands';
  final String cartCollection = 'cart';
  final String ordersCollection = 'orders';

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    try {
      // Initialize Users Collection with sample data
      final usersSnapshot = await _firestore.collection(usersCollection).limit(1).get();
      if (usersSnapshot.docs.isEmpty) {
        final List<Map<String, dynamic>> users = [
          {
            'uid': 'sample_user_1',
            'email': 'john@example.com',
            'displayName': 'John Doe',
            'phoneNumber': '+1234567890',
            'address': {
              'street': '123 Main St',
              'city': 'New York',
              'state': 'NY',
              'zipCode': '10001',
              'country': 'USA'
            },
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
            'favoriteProducts': [],
            'recentlyViewed': []
          }
        ];

        for (final user in users) {
          await _firestore.collection(usersCollection).doc(user['uid']).set(user);
        }
        debugPrint('Users added to Firestore');
      }

      // Initialize Categories
      final categoriesSnapshot = await _firestore.collection(categoriesCollection).limit(1).get();
      if (categoriesSnapshot.docs.isEmpty) {
        final List<Map<String, dynamic>> categories = [
          {
            'name': 'Running',
            'description': 'High-performance running shoes for all types of runners',
            'icon': 'running',
            'image': 'https://example.com/running.jpg',
            'featured': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Basketball',
            'description': 'Professional basketball shoes for court performance',
            'icon': 'basketball',
            'image': 'https://example.com/basketball.jpg',
            'featured': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Casual',
            'description': 'Comfortable everyday shoes for casual wear',
            'icon': 'casual',
            'image': 'https://example.com/casual.jpg',
            'featured': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Training',
            'description': 'Versatile training shoes for gym and fitness',
            'icon': 'training',
            'image': 'https://example.com/training.jpg',
            'featured': false,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }
        ];

        for (final category in categories) {
          await _firestore.collection(categoriesCollection).add(category);
        }
        debugPrint('Categories added to Firestore');
      }

      // Initialize Cart Collection Structure
      final cartSnapshot = await _firestore.collection(cartCollection).limit(1).get();
      if (cartSnapshot.docs.isEmpty) {
        final sampleCart = {
          'userId': 'sample_user_1',
          'items': [
            {
              'productId': 'sample_product_1',
              'quantity': 1,
              'size': 'US 9',
              'color': 'Black/White',
              'price': 149.99,
              'addedAt': FieldValue.serverTimestamp(),
            }
          ],
          'totalAmount': 149.99,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection(cartCollection).add(sampleCart);
        debugPrint('Cart collection structure initialized');
      }

      // Initialize Orders Collection Structure
      final ordersSnapshot = await _firestore.collection(ordersCollection).limit(1).get();
      if (ordersSnapshot.docs.isEmpty) {
        final sampleOrder = {
          'orderId': 'ORD-2024-001',
          'userId': 'sample_user_1',
          'items': [
            {
              'productId': 'sample_product_1',
              'quantity': 1,
              'size': 'US 9',
              'color': 'Black/White',
              'price': 149.99,
            }
          ],
          'totalAmount': 149.99,
          'shippingAddress': {
            'street': '123 Main St',
            'city': 'New York',
            'state': 'NY',
            'zipCode': '10001',
            'country': 'USA'
          },
          'paymentMethod': 'Credit Card',
          'paymentStatus': 'Paid',
          'orderStatus': 'Processing',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'estimatedDeliveryDate': Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 5)),
          ),
        };

        await _firestore.collection(ordersCollection).add(sampleOrder);
        debugPrint('Orders collection structure initialized');
      }

      // Initialize Products with references to categories and brands
      final productsSnapshot = await _firestore.collection(productsCollection).limit(1).get();
      if (productsSnapshot.docs.isEmpty) {
        final List<Map<String, dynamic>> products = [
          {
            'name': 'Nike Air Max 270',
            'description': 'The Nike Air Max 270 delivers visible cushioning under every step.',
            'price': 149.99,
            'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-max-270-shoes-2V5C4p.png',
            'images': [
              'https://example.com/nike-air-max-270-1.jpg',
              'https://example.com/nike-air-max-270-2.jpg',
              'https://example.com/nike-air-max-270-3.jpg',
            ],
            'stock': 15,
            'brand': 'Nike',
            'category': 'Running',
            'features': [
              'Responsive cushioning',
              'Breathable mesh upper',
              'Durable rubber outsole'
            ],
            'sizes': ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
            'colors': ['Black/White', 'White/Red', 'Blue/Grey'],
            'rating': 4.5,
            'reviewCount': 128,
            'featured': true,
            'onSale': false,
            'salePrice': null,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Adidas UltraBoost',
            'description': 'UltraBoost shoes with responsive cushioning and a sock-like fit.',
            'price': 179.99,
            'imageUrl': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/69cbc73d0cb846889f89acbb011e68cb_9366/UltraBoost_Light_Shoes_Black_GX3062_01_standard.jpg',
            'stock': 20,
            'brand': 'Adidas',
            'category': 'Running',
            'features': [
              'Boost cushioning',
              'PrimeKnit upper',
              'Continental™ Rubber outsole'
            ],
            'sizes': ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
            'colors': ['Core Black', 'Cloud White', 'Grey'],
            'rating': 4.8,
            'reviewCount': 256,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Puma RS-X',
            'description': 'The RS-X Toys reinvents the 80s Running System line with a modern build.',
            'price': 129.99,
            'imageUrl': 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_1350,h_1350/global/369449/01/sv01/fnd/IND/fmt/png/RS-X-Toys-Sneakers',
            'stock': 12,
            'brand': 'Puma',
            'category': 'Casual',
            'features': [
              'Running System technology',
              'Mesh and textile upper',
              'Rubber outsole'
            ],
            'sizes': ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
            'colors': ['White/Blue', 'Black/Red', 'Grey/Yellow'],
            'rating': 4.3,
            'reviewCount': 89,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }
        ];

        for (final product in products) {
          await _firestore.collection(productsCollection).add(product);
        }
        debugPrint('Products added to Firestore');
      }
    } catch (e) {
      debugPrint('Error initializing database: $e');
    }
  }

  // Create: Add a new product
  Future<String?> createProduct(Product product) async {
    try {
      final docRef = await _firestore.collection(productsCollection).add(product.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating product: $e');
      return null;
    }
  }

  // Read: Get all products as a stream
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(productsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              return Product.fromMap(doc.id, doc.data());
            })
            .toList());
  }

  // Read: Get a single product
  Future<Product?> getProduct(String id) async {
    try {
      final docSnapshot = await _firestore.collection(productsCollection).doc(id).get();
      if (docSnapshot.exists) {
        return Product.fromMap(docSnapshot.id, docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting product: $e');
      return null;
    }
  }

  // Update: Update a product
  Future<bool> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection(productsCollection).doc(id).update(product.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  // Delete: Delete a product
  Future<bool> deleteProduct(String id) async {
    try {
      await _firestore.collection(productsCollection).doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  // User CRUD operations
  
  // Read: Get all users
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(usersCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Create: Add a new user
  Future<String?> createUser(UserModel user) async {
    try {
      final docRef = await _firestore.collection(usersCollection).add(user.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return null;
    }
  }

  // Read: Get a single user
  Future<UserModel?> getUser(String id) async {
    try {
      final docSnapshot = await _firestore.collection(usersCollection).doc(id).get();
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // Update: Update a user
  Future<bool> updateUser(String id, UserModel user) async {
    try {
      await _firestore.collection(usersCollection).doc(id).update(user.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  // Delete: Delete a user
  Future<bool> deleteUser(String id) async {
    try {
      await _firestore.collection(usersCollection).doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update(updates);
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }

  // Get user orders
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }
  
  // Search products by name
  Stream<List<Product>> searchProducts(String searchTerm) {
    return _firestore
        .collection(productsCollection)
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThan: searchTerm + 'z')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Product.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
} 