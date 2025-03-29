import 'package:get/get.dart';
import '../controllers/product_search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductSearchController>(
      () => ProductSearchController(),
    );
  }
} 