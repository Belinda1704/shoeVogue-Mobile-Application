import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final _isOnboardingCompleted = false.obs;

  bool get isOnboardingCompleted => _isOnboardingCompleted.value;

  @override
  void onInit() {
    super.onInit();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingCompleted.value = prefs.getBool('onboarding_completed') ?? false;
    
    if (_isOnboardingCompleted.value) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    _isOnboardingCompleted.value = true;
  }
} 