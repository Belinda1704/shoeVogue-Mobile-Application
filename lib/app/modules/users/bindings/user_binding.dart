import 'package:get/get.dart';
import '../../../services/firestore_service.dart';
import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService(), fenix: true);
    Get.lazyPut<UserController>(() => UserController());
  }
} 