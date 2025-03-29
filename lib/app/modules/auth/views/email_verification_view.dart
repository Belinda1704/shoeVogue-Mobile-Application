import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class EmailVerificationView extends GetView {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());
    
    // Call startVerificationCheck when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startVerificationCheck();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                Text(
                  'Verification Email Sent',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Obx(() => Text(
                  'We\'ve sent a verification email to\n${controller.email}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 8),
                Text(
                  'Please check your inbox and click the verification link to complete your registration.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Obx(() => controller.isVerified.value
                  ? ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Email Verified'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )
                  : const CircularProgressIndicator()
                ),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () => controller.resendVerificationEmail(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Resend Email'),
                ),
                TextButton(
                  onPressed: () => controller.goToLogin(),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerificationController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final isVerified = false.obs;
  Timer? timer;
  
  String get email => authService.currentUserData?.email ?? 'your email';
  
  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
  
  void startVerificationCheck() {
    checkEmailVerified();
  }
  
  void checkEmailVerified() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final verified = await authService.checkEmailVerified();
      if (verified) {
        isVerified.value = true;
        timer?.cancel();
        
        // Show success message
        Get.snackbar(
          'Success',
          'Email verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to home after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed('/home');
        });
      }
    });
  }
  
  void resendVerificationEmail() async {
    await authService.sendEmailVerification();
  }
  
  void goToLogin() {
    timer?.cancel();
    authService.signOut();
    Get.offAllNamed('/login');
  }
} 