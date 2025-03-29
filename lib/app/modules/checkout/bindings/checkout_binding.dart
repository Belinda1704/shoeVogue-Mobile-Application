import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../../services/payment_service.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure PaymentService is initialized first
    if (!Get.isRegistered<PaymentService>()) {
      Get.put(PaymentService());
    }
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
} 