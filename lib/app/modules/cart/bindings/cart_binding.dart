import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Only put if not found to avoid overwriting existing instance
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
  }
} 