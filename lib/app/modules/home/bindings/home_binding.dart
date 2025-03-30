import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../categories/controllers/category_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(),
      permanent: true,
    );
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
  }
} 