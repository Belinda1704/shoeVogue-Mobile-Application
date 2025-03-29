import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../../utils/constants/image_strings.dart';

class HomeController extends GetxController {
  // Observable variables
  final _currentIndex = 0.obs;
  final _products = <Map<String, dynamic>>[].obs;
  final _selectedCategory = 'All'.obs;
  final _filteredProducts = <Map<String, dynamic>>[].obs;

  // Getters
  int get currentIndex => _currentIndex.value;
  List<Map<String, dynamic>> get products => _products;
  String get selectedCategory => _selectedCategory.value;
  List<Map<String, dynamic>> get filteredProducts => _filteredProducts;

  // Setters
  set currentIndex(int value) => _currentIndex.value = value;
  set selectedCategory(String value) {
    _selectedCategory.value = value;
    filterProducts();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
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
      product['isFavorite'] = !(product['isFavorite'] ?? false);
      _products[index] = product;
      filterProducts();
    }
  }

  void addToCart(String productId) {
    Get.snackbar(
      'Added to Cart',
      'Product added to your cart successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
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
        'imageUrl': 'assets/images/products/TennisCasualAdidas.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '10',
        'name': 'Adidas',
        'price': 139.99,
        'imageUrl': 'assets/images/products/Addidas1.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '11',
        'name': 'Airforce 2',
        'price': 149.99,
        'imageUrl': 'assets/images/products/Airfoce2.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '12',
        'name': 'Airforce 1',
        'price': 159.99,
        'imageUrl': 'assets/images/products/Airforce1.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '13',
        'name': 'Jordan 5',
        'price': 219.99,
        'imageUrl': 'assets/images/products/Jordan5.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '14',
        'name': 'New Balance 4',
        'price': 109.99,
        'imageUrl': 'assets/images/products/NewBalance4.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '15',
        'name': 'New Balance 5',
        'price': 119.99,
        'imageUrl': 'assets/images/products/NewBalance5.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '16',
        'name': 'New Balance 6',
        'price': 129.99,
        'imageUrl': 'assets/images/products/NewBalance6.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '17',
        'name': 'Nike Defy',
        'price': 149.99,
        'imageUrl': 'assets/images/products/NikeDefy.png',
        'category': 'Sneakers',
        'isFavorite': false,
      },
      {
        'id': '18',
        'name': 'Nike Pull Up',
        'price': 139.99,
        'imageUrl': 'assets/images/products/NikePullUp.png',
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
        'imageUrl': "assets/images/products/WomensShoe.png",
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
} 