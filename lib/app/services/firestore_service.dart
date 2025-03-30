import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/models/user_model.dart';
import '../data/models/banner_model.dart';
import '../data/models/category_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection names
  final String usersCollection = 'users';
  final String productsCollection = 'products';
  final String categoriesCollection = 'categories';
  final String brandsCollection = 'brands';
  final String cartCollection = 'cart';
  final String ordersCollection = 'orders';
  final String bannersCollection = 'banners';

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
    initializeDefaultCategories();
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

      // Initialize Banners collection
      final bannersSnapshot = await _firestore.collection(bannersCollection).limit(1).get();
      if (bannersSnapshot.docs.isEmpty) {
        final List<Map<String, dynamic>> banners = [
          {
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/shoevogueapp.appspot.com/o/banners%2Fbanner1.jpg?alt=media',
            'title': 'Summer Sale',
            'subtitle': 'Up to 50% off on select items',
            'actionText': 'Shop Now',
            'actionUrl': '/products?category=summer-sale',
            'isActive': true,
            'priority': 1,
            'startDate': FieldValue.serverTimestamp(),
            'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
          },
          {
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/shoevogueapp.appspot.com/o/banners%2Fbanner2.jpg?alt=media',
            'title': 'New Arrivals',
            'subtitle': 'Check out our latest collection',
            'actionText': 'Explore',
            'actionUrl': '/products?category=new-arrivals',
            'isActive': true,
            'priority': 2,
            'startDate': FieldValue.serverTimestamp(),
            'endDate': null,
          },
        ];

        for (final banner in banners) {
          await _firestore.collection(bannersCollection).add(banner);
        }
        debugPrint('Sample banners added to Firestore');
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

  // Create or update user data (used by auth service)
  Future<void> createOrUpdateUser(Map<String, dynamic> userData) async {
    try {
      final String uid = userData['uid'];
      final userDoc = _firestore.collection(usersCollection).doc(uid);
      
      // Check if user exists
      final docSnapshot = await userDoc.get();
      
      if (docSnapshot.exists) {
        // Update existing user
        await userDoc.update(userData);
      } else {
        // Create new user
        await userDoc.set(userData);
      }
    } catch (e) {
      debugPrint('Error in createOrUpdateUser: $e');
      throw e;
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

  // Banner operations
  
  // Get all active banners as stream
  Stream<List<BannerModel>> getBanners() {
    return _firestore
        .collection(bannersCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('priority')
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          return snapshot.docs
              .map((doc) => BannerModel.fromMap(doc.data(), doc.id))
              .where((banner) {
                // Filter by date range if specified
                if (banner.startDate != null && now.isBefore(banner.startDate!)) {
                  return false;
                }
                if (banner.endDate != null && now.isAfter(banner.endDate!)) {
                  return false;
                }
                return true;
              })
              .toList();
        });
  }
  
  // Add a new banner
  Future<String?> createBanner(BannerModel banner) async {
    try {
      final docRef = await _firestore.collection(bannersCollection).add(banner.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating banner: $e');
      return null;
    }
  }
  
  // Update a banner
  Future<bool> updateBanner(String id, BannerModel banner) async {
    try {
      await _firestore.collection(bannersCollection).doc(id).update(banner.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating banner: $e');
      return false;
    }
  }
  
  // Delete a banner
  Future<bool> deleteBanner(String id) async {
    try {
      await _firestore.collection(bannersCollection).doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting banner: $e');
      return false;
    }
  }

  // Add a product to user's favorites
  Future<bool> addToFavorites(String userId, String productId) async {
    try {
      final userDoc = _firestore.collection(usersCollection).doc(userId);
      
      // Get current user data
      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        debugPrint('User document does not exist');
        return false;
      }
      
      // Get current favorites
      List<String> favorites = List<String>.from(userSnapshot.data()?['favoriteProducts'] ?? []);
      
      // Add product if not already in favorites
      if (!favorites.contains(productId)) {
        favorites.add(productId);
        await userDoc.update({
          'favoriteProducts': favorites,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Product added to favorites');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove a product from user's favorites
  Future<bool> removeFromFavorites(String userId, String productId) async {
    try {
      final userDoc = _firestore.collection(usersCollection).doc(userId);
      
      // Get current user data
      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        debugPrint('User document does not exist');
        return false;
      }
      
      // Get current favorites
      List<String> favorites = List<String>.from(userSnapshot.data()?['favoriteProducts'] ?? []);
      
      // Remove product if it exists in favorites
      if (favorites.contains(productId)) {
        favorites.remove(productId);
        await userDoc.update({
          'favoriteProducts': favorites,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Product removed from favorites');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  // Get user's favorite products
  Future<List<Product>> getUserFavoriteProducts(String userId) async {
    try {
      // Get the user's favorite product IDs
      final userDoc = await _firestore.collection(usersCollection).doc(userId).get();
      if (!userDoc.exists) {
        debugPrint('User document does not exist');
        return [];
      }
      
      List<String> favoriteIds = List<String>.from(userDoc.data()?['favoriteProducts'] ?? []);
      
      if (favoriteIds.isEmpty) {
        return [];
      }
      
      // Get the product details for each favorite ID
      final productsQuery = await _firestore
          .collection(productsCollection)
          .where(FieldPath.documentId, whereIn: favoriteIds)
          .get();
          
      return productsQuery.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting favorite products: $e');
      return [];
    }
  }

  // Check if a product is in user's favorites
  Future<bool> isProductFavorite(String userId, String productId) async {
    try {
      final userDoc = await _firestore.collection(usersCollection).doc(userId).get();
      if (!userDoc.exists) {
        return false;
      }
      
      List<String> favorites = List<String>.from(userDoc.data()?['favoriteProducts'] ?? []);
      return favorites.contains(productId);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

  // Get all product categories
  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection(categoriesCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CategoryModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Create a new category
  Future<String?> createCategory(CategoryModel category) async {
    try {
      final docRef = await _firestore.collection(categoriesCollection).add(category.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating category: $e');
      return null;
    }
  }

  // Update a category
  Future<bool> updateCategory(String id, CategoryModel category) async {
    try {
      await _firestore.collection(categoriesCollection).doc(id).update(category.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating category: $e');
      return false;
    }
  }

  // Delete a category
  Future<bool> deleteCategory(String id) async {
    try {
      await _firestore.collection(categoriesCollection).doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting category: $e');
      return false;
    }
  }

  // Initialize default categories if none exist
  Future<void> initializeDefaultCategories() async {
    try {
      final categoriesSnapshot = await _firestore.collection(categoriesCollection).limit(1).get();
      if (categoriesSnapshot.docs.isEmpty) {
        final List<CategoryModel> categories = [
          CategoryModel(
            name: 'Sneakers',
            description: 'Athletic and casual sneakers for everyday wear',
            icon: 'shoe',
            featured: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            name: 'Formal',
            description: 'Formal and dress shoes for professional settings',
            icon: 'business-shoe',
            featured: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            name: 'Sports',
            description: 'Performance shoes for athletic activities',
            icon: 'running-shoe',
            featured: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryModel(
            name: 'Casual',
            description: 'Comfortable shoes for everyday casual wear',
            icon: 'casual-shoe', 
            featured: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        for (final category in categories) {
          await _firestore.collection(categoriesCollection).add(category.toMap());
        }
        debugPrint('Default categories initialized');
      }
    } catch (e) {
      debugPrint('Error initializing default categories: $e');
    }
  }

  // Add an item to user's cart
  Future<bool> addToCart(String userId, Map<String, dynamic> item) async {
    try {
      final userCartRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('cart');
      
      // Use product ID as document ID
      final String itemId = item['id'].toString();
      
      // First check if the item already exists
      final existingDoc = await userCartRef.doc(itemId).get();
      
      if (existingDoc.exists) {
        // Update existing item (modify quantity)
        final existingData = existingDoc.data() ?? {};
        final int currentQuantity = existingData['quantity'] ?? 1;
        final int newQuantity = (item['quantity'] ?? 1) + currentQuantity;
        
        // Update quantity and total price
        item['quantity'] = newQuantity;
        item['totalPrice'] = (item['price'] ?? 0.0) * newQuantity;
        
        await userCartRef.doc(itemId).update(item);
        debugPrint('Updated quantity for item in cart: $itemId');
      } else {
        // Add new item
        await userCartRef.doc(itemId).set(item);
        debugPrint('Added new item to cart: $itemId');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      return false;
    }
  }
  
  // Get all items in user's cart
  Future<List<Map<String, dynamic>>> getUserCartItems(String userId) async {
    try {
      final userCartRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('cart');
      
      final cartSnapshot = await userCartRef.get();
      
      if (cartSnapshot.docs.isEmpty) {
        return [];
      }
      
      return cartSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting cart items: $e');
      return [];
    }
  }
  
  // Remove an item from user's cart
  Future<bool> removeFromCart(String userId, String itemId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .delete();
      
      debugPrint('Removed item from cart: $itemId');
      return true;
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      return false;
    }
  }
  
  // Clear all items from user's cart
  Future<bool> clearCart(String userId) async {
    try {
      final cartRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('cart');
      
      final batch = _firestore.batch();
      final snapshots = await cartRef.get();
      
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
      debugPrint('Cart cleared for user: $userId');
      return true;
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      return false;
    }
  }
} 