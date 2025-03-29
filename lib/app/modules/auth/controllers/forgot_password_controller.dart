import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final emailController = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  void setEmail(String value) => emailController.value = value;

  Future<void> resetPassword() async {
    if (emailController.value.isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return;
    }

    if (!GetUtils.isEmail(emailController.value)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      await _authService.resetPassword(emailController.value);
      
      successMessage.value = 'Password reset link has been sent to your email';
      Get.back(); // Return to login screen
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage.value = 'No user found with this email address';
          break;
        case 'invalid-email':
          errorMessage.value = 'Invalid email address';
          break;
        default:
          errorMessage.value = 'An error occurred. Please try again later';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again later';
    } finally {
      isLoading.value = false;
    }
  }
} 