import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final _isLoggedIn = false.obs;
  final _isFirstTime = true.obs;
  final _currentPage = 0.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  bool get isFirstTime => _isFirstTime.value;
  int get currentPage => _currentPage.value;

  @override
  void onInit() {
    super.onInit();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime.value = prefs.getBool('isFirstTime') ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
    _isFirstTime.value = value;
  }

  void setCurrentPage(int page) {
    _currentPage.value = page;
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic
    _isLoggedIn.value = true;
    Get.offAllNamed('/home');
  }

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
  }) async {
    // TODO: Implement actual signup logic
    _isLoggedIn.value = true;
    Get.offAllNamed('/home');
  }

  Future<void> logout() async {
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  Future<void> resetPassword(String email) async {
    // TODO: Implement password reset logic
    Get.back();
  }

  Future<void> verifyEmail(String code) async {
    // TODO: Implement email verification logic
    Get.offAllNamed('/home');
  }
} 