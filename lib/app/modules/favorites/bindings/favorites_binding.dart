import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(
      FavoritesController(),
      permanent: true,
    );
  }
} 