import 'package:get/get.dart';
import '../../../services/firestore_service.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirestoreService(), permanent: true);
    Get.lazyPut(() => ProductController());
  }
} 