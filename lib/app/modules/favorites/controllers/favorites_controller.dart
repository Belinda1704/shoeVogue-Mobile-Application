import 'package:get/get.dart';

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String brand;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.brand,
  });
}

class FavoritesController extends GetxController {
  final _items = <FavoriteItem>[].obs;
  final _isLoading = false.obs;

  List<FavoriteItem> get items => _items;
  bool get isLoading => _isLoading.value;

  void addToFavorites(FavoriteItem item) {
    if (!_items.any((i) => i.id == item.id)) {
      _items.add(item);
    }
  }

  void removeFromFavorites(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  bool isFavorite(String id) {
    return _items.any((item) => item.id == id);
  }

  Future<void> addToCart(FavoriteItem item) async {
    _isLoading.value = true;
    // TODO: Implement add to cart logic
    await Future.delayed(const Duration(seconds: 1)); // Simulated API call
    Get.toNamed('/cart');
    _isLoading.value = false;
  }
} 