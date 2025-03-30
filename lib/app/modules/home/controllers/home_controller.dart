import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'dart:async';
import '../../../services/firestore_service.dart';
import '../../../data/models/banner_model.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../../services/auth_service.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final FavoritesController _favoritesController = Get.find<FavoritesController>();
  final AuthService _authService = Get.find<AuthService>();
  
  // Observable variables
  final _currentIndex = 0.obs;
  final _products = <Map<String, dynamic>>[].obs;
  final _selectedCategory = 'All'.obs;
  final _filteredProducts = <Map<String, dynamic>>[].obs;
  final _banners = <BannerModel>[].obs;
  final _isLoadingBanners = true.obs;
  
  // Stream subscriptions
  StreamSubscription<List<BannerModel>>? _bannersSubscription;

  // Getters
  int get currentIndex => _currentIndex.value;
  List<Map<String, dynamic>> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  List<Map<String, dynamic>> get filteredProducts => _filteredProducts;
  List<BannerModel> get banners => _banners;
  bool get isLoadingBanners => _isLoadingBanners.value;

  // Setters
  set currentIndex(int value) => _currentIndex.value = value;
  set selectedCategory(String value) {
    _selectedCategory.value = value;
    filterProducts();
  }

  @override
  void onInit() {
    super.onInit();
    _currentIndex.value = 0;
    _selectedCategory.value = 'All';
    loadBanners();
    loadProducts();
    syncFavoritesFromFirestore();
  }
  
  @override
  void onClose() {
    _bannersSubscription?.cancel();
    super.onClose();
  }

  void loadBanners() {
    try {
      _isLoadingBanners.value = true;
      _bannersSubscription = _firestoreService.getBanners().listen(
        (bannerList) {
          if (bannerList.isEmpty) {
            // If Firebase banners are empty, use local assets
            _loadLocalBanners();
          } else {
            _banners.value = bannerList;
          }
          _isLoadingBanners.value = false;
        },
        onError: (error) {
          debugPrint('Error loading banners from Firebase: $error');
          // On error, fallback to local banners
          _loadLocalBanners();
          _isLoadingBanners.value = false;
        }
      );
    } catch (e) {
      debugPrint('Error subscribing to banners: $e');
      // On exception, fallback to local banners
      _loadLocalBanners();
      _isLoadingBanners.value = false;
    }
  }

  void _loadLocalBanners() {
    final List<BannerModel> localBanners = [
      BannerModel(
        id: 'local_banner_1',
        imageUrl: 'assets/images/banners/banner_1.jpg',
        title: 'Summer Collection',
        subtitle: 'Check out our latest summer styles',
        actionText: 'Shop Now',
        actionUrl: '/products?category=summer',
        isActive: true,
        priority: 1,
      ),
      BannerModel(
        id: 'local_banner_2',
        imageUrl: 'assets/images/banners/banner_2.jpg',
        title: 'Limited Edition',
        subtitle: 'Get them before they\'re gone',
        actionText: 'Explore',
        actionUrl: '/products?category=limited',
        isActive: true,
        priority: 2,
      ),
      BannerModel(
        id: 'local_banner_3',
        imageUrl: 'assets/images/banners/banner_3.jpg',
        title: 'Special Discount',
        subtitle: 'Up to 50% off on select items',
        actionText: 'View Offers',
        actionUrl: '/products?category=sale',
        isActive: true,
        priority: 3,
      ),
    ];
    
    _banners.value = localBanners;
    debugPrint('Using local banner assets as fallback');
  }

  void changePage(int index) => currentIndex = index;

  void changeCategory(String category) => selectedCategory = category;

  void filterProducts() {
    if (_selectedCategory.value == 'All') {
      _filteredProducts.value = _products;
    } else {
      _filteredProducts.value = _products
          .where((product) => product['category'] == _selectedCategory.value)
          .toList();
    }
  }

  void toggleFavorite(String id) {
    final index = _products.indexWhere((product) => product['id'] == id);
    if (index != -1) {
      final product = Map<String, dynamic>.from(_products[index]);
      final bool newFavoriteStatus = !(product['isFavorite'] ?? false);
      
      // Check if user is logged in
      final String? userId = _authService.currentUser.value?.uid;
      if (userId == null) {
        Get.snackbar(
          'Sign In Required',
          'Please sign in to save your favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Update local UI state
      product['isFavorite'] = newFavoriteStatus;
      _products[index] = product;
      
      // Update favorites in Firestore
      if (newFavoriteStatus) {
        _firestoreService.addToFavorites(userId, id).then((success) {
          if (success) {
            debugPrint('Added product $id to favorites in Firestore');
          } else {
            debugPrint('Failed to add product $id to favorites in Firestore');
          }
        });
      } else {
        _firestoreService.removeFromFavorites(userId, id).then((success) {
          if (success) {
            debugPrint('Removed product $id from favorites in Firestore');
          } else {
            debugPrint('Failed to remove product $id from favorites in Firestore');
          }
        });
      }
      
      // Refresh the UI
      _products.refresh();
      filterProducts();
      
      // Show feedback to user
      Get.snackbar(
        'Favorites Updated',
        newFavoriteStatus ? 'Added to favorites' : 'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addToCart(String productId) {
    try {
      // Find the product in products list
      final product = _products.firstWhere(
        (product) => product['id'] == productId,
        orElse: () => throw Exception('Product not found'),
      );
      
      // Get the cart controller
      final cartController = Get.find<CartController>();
      
      // Add the product to cart
      cartController.addToCart(product);
      
      // Show success message
      Get.snackbar(
        'Added to Cart',
        '${product['name']} added to your cart successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Could not add product to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void loadProducts() {
    _products.value = [
      // Sneakers Category
      {
        'id': '1',
        'name': 'Nike Air Jordan Orange',
        'price': 199.99,
        'imageUrl': 'assets/images/products/NikeAirJOrdonOrange.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '2',
        'name': 'Nike Air Jordan Blue',
        'price': 189.99,
        'imageUrl': 'assets/images/products/NikeAirJordonSingleBlue.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '3',
        'name': 'Nike Air Jordan Black Red',
        'price': 209.99,
        'imageUrl': 'assets/images/products/NikeAirJOrdonBlackRed.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '4',
        'name': 'Nike Air Jordan White Red',
        'price': 199.99,
        'imageUrl': 'assets/images/products/NikeAirJOrdonWhiteRed.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '5',
        'name': 'Nike Air Jordan White Magenta',
        'price': 189.99,
        'imageUrl': 'assets/images/products/NikeAirJordonwhiteMagenta.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '6',
        'name': 'Nike Air Jordan Single Orange',
        'price': 179.99,
        'imageUrl': 'assets/images/products/NikeAirJordonSingleOrange.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '7',
        'name': 'Nike Air Max',
        'price': 159.99,
        'imageUrl': 'assets/images/products/NikeAirMax.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '8',
        'name': 'Yeezy',
        'price': 299.99,
        'imageUrl': 'assets/images/products/Yezzys.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '9',
        'name': 'Adidas Casual',
        'price': 129.99,
        'imageUrl': 'assets/images/products/NikeAirMax.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '10',
        'name': 'Adidas',
        'price': 139.99,
        'imageUrl': 'assets/images/products/Addidas 1.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '11',
        'name': 'Airforce 2',
        'price': 149.99,
        'imageUrl': 'assets/images/products/Airfoce 2.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '12',
        'name': 'Airforce 1',
        'price': 159.99,
        'imageUrl': 'assets/images/products/Airforce 1.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '13',
        'name': 'Jordan 5',
        'price': 219.99,
        'imageUrl': 'assets/images/products/Jordan 5.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '14',
        'name': 'New Balance 4',
        'price': 109.99,
        'imageUrl': 'assets/images/products/New Balance 4.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '15',
        'name': 'New Balance 5',
        'price': 119.99,
        'imageUrl': 'assets/images/products/New Balance 5.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '16',
        'name': 'New Balance 6',
        'price': 129.99,
        'imageUrl': 'assets/images/products/New Balance 6.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '17',
        'name': 'Nike Defy',
        'price': 149.99,
        'imageUrl': 'assets/images/products/Nike Defy.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '18',
        'name': 'Nike Pull Up',
        'price': 139.99,
        'imageUrl': 'assets/images/products/Nike pull up.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '19',
        'name': 'Plaid Nikes',
        'price': 169.99,
        'imageUrl': TImages.productImage21,
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '20',
        'name': "Women's Air Jordan",
        'price': 189.99,
        'imageUrl': TImages.productImage24,
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '21',
        'name': 'Nike Shoes Classic',
        'price': 159.99,
        'imageUrl': TImages.productImage1,
        'category': 'Sneakers',
        'isFavorite': false,
      },

      // Formal Category
      {
        'id': '22',
        'name': 'Prada Leather',
        'price': 399.99,
        'imageUrl': TImages.productImage22,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '23',
        'name': 'Leather Shoes',
        'price': 249.99,
        'imageUrl': TImages.productImage36,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '24',
        'name': 'Loafer',
        'price': 179.99,
        'imageUrl': TImages.productImage37,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '25',
        'name': 'Men Formal',
        'price': 189.99,
        'imageUrl': TImages.productImage49,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '26',
        'name': 'Lace Leather Men Shoe',
        'price': 229.99,
        'imageUrl': TImages.productImage35,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '27',
        'name': 'The D\'Orsay',
        'price': 259.99,
        'imageUrl': TImages.productImage43,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '28',
        'name': 'Stiletto',
        'price': 239.99,
        'imageUrl': TImages.productImage48,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '29',
        'name': 'Zara Heels',
        'price': 199.99,
        'imageUrl': TImages.productImage47,
        'category': 'Formal',
        'isFavorite': false,
      },
      {
        'id': '30',
        'name': 'Hot Talon',
        'price': 189.99,
        'imageUrl': TImages.productImage20,
        'category': 'Formal',
        'isFavorite': false,
      },

      // Sports Category
      {
        'id': '31',
        'name': 'Nike Basketball Shoe',
        'price': 169.99,
        'imageUrl': TImages.productImage13,
        'category': 'Sports',
        'isFavorite': false,
      },
      {
        'id': '32',
        'name': 'Nike Wildhorse',
        'price': 159.99,
        'imageUrl': TImages.productImage14,
        'category': 'Sports',
        'isFavorite': false,
      },
      {
        'id': '33',
        'name': 'Sportwear',
        'price': 149.99,
        'imageUrl': TImages.productImage46,
        'category': 'Sports',
        'isFavorite': false,
      },
      {
        'id': '34',
        'name': "Women's Shoe",
        'price': 139.99,
        'imageUrl': "assets/images/products/Women's Shoe.png",
        'category': 'Sports',
        'isFavorite': false,
      },
      {
        'id': '35',
        'name': 'Chaussures',
        'price': 149.99,
        'imageUrl': TImages.productImage19,
        'category': 'Sports',
        'isFavorite': false,
      },

      // Casual Category
      {
        'id': '36',
        'name': 'Casual Vans',
        'price': 89.99,
        'imageUrl': TImages.productImage32,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '37',
        'name': 'Women Vans',
        'price': 84.99,
        'imageUrl': TImages.productImage33,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '38',
        'name': 'Vans Old Skool',
        'price': 79.99,
        'imageUrl': TImages.productImage44,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '39',
        'name': 'White Vans',
        'price': 74.99,
        'imageUrl': TImages.productImage45,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '40',
        'name': 'Adidas Samba',
        'price': 99.99,
        'imageUrl': TImages.productImage23,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '41',
        'name': "Women's Sandals",
        'price': 69.99,
        'imageUrl': TImages.productImage26,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '42',
        'name': 'Slipper Product 1',
        'price': 49.99,
        'imageUrl': TImages.productImage15,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '43',
        'name': 'Slipper Product 2',
        'price': 44.99,
        'imageUrl': TImages.productImage16,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '44',
        'name': 'Slipper Product 3',
        'price': 39.99,
        'imageUrl': TImages.productImage17,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '45',
        'name': 'Slipper Product',
        'price': 34.99,
        'imageUrl': TImages.productImage18,
        'category': 'Casual',
        'isFavorite': false,
      },
      {
        'id': '46',
        'name': 'Product Slippers',
        'price': 29.99,
        'imageUrl': TImages.productImage3,
        'category': 'Casual',
        'isFavorite': false,
      },
    ];
    
    filterProducts();
  }

  // Sync favorite status from Firestore
  Future<void> syncFavoritesFromFirestore() async {
    // Check if user is logged in
    final String? userId = _authService.currentUser.value?.uid;
    if (userId == null) {
      debugPrint('User not logged in, skipping favorites sync');
      return;
    }
    
    try {
      // Get user document from Firestore
      final userDoc = await _firestoreService.getUser(userId);
      if (userDoc == null) {
        debugPrint('User document not found in Firestore');
        return;
      }
      
      // Get favorite product IDs
      final List<String> favoriteIds = List<String>.from(userDoc.favoriteProducts);
      debugPrint('Retrieved ${favoriteIds.length} favorite products from Firestore');
      
      // Update local products with favorite status
      for (int i = 0; i < _products.length; i++) {
        final product = Map<String, dynamic>.from(_products[i]);
        final String productId = product['id'].toString();
        
        // Set isFavorite based on whether the ID exists in favoriteIds
        product['isFavorite'] = favoriteIds.contains(productId);
        _products[i] = product;
      }
      
      // Refresh products in UI
      _products.refresh();
      filterProducts();
    } catch (e) {
      debugPrint('Error syncing favorites from Firestore: $e');
    }
  }
} 