import 'package:get/get.dart';
import '../controllers/ai_features_controller.dart';

class AiFeaturesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiFeaturesController>(
      () => AiFeaturesController(),
    );
  }
} 