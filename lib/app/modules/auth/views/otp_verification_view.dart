import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'package:flutter/foundation.dart';

class OTPVerificationView extends GetView {
  const OTPVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPVerificationController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Enter verification code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a verification code to your phone. Please enter it below.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              // OTP Text Field
              TextField(
                controller: controller.otpController,
                decoration: InputDecoration(
                  hintText: '6-digit code',
                  prefixIcon: Icon(Icons.sms_outlined, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: controller.otpError.value.isEmpty 
                    ? null 
                    : controller.otpError.value,
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (controller.otpError.value.isNotEmpty) {
                    controller.otpError.value = '';
                  }
                  // Auto-verify when 6 digits are entered
                  if (value.length == 6) {
                    controller.verifyOTP();
                  }
                },
              ),
              const SizedBox(height: 24),
              // Verify OTP button
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.verifyOTP(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Verifying...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Verify Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
              const SizedBox(height: 16),
              // Timer & Resend section
              Obx(() => Column(
                children: [
                  controller.showTimer.value
                    ? Text(
                        'Resend code in ${controller.timeLeft.value} seconds',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Didn\'t receive a code?'),
                          TextButton(
                            onPressed: controller.isLoading.value 
                              ? null 
                              : () => controller.resendCode(),
                            child: const Text('Resend'),
                          ),
                        ],
                      ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPVerificationController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;
  final otpError = ''.obs;
  final authService = Get.find<AuthService>();
  
  // Timer related fields
  final timeLeft = 30.obs;
  final showTimer = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }
  
  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
  
  void startTimer() {
    timeLeft.value = 30;
    showTimer.value = true;
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      timeLeft.value--;
      if (timeLeft.value <= 0) {
        showTimer.value = false;
        return false;
      }
      return true;
    });
  }
  
  void resendCode() async {
    isLoading.value = true;
    
    try {
      // Get phone number from previous screen or storage
      // For now, we'll just go back to the phone input screen
      Get.back();
    } catch (e) {
      otpError.value = 'Failed to resend code. Try again.';
    } finally {
      isLoading.value = false;
    }
  }
  
  void verifyOTP() async {
    final otp = otpController.text.trim();
    
    if (otp.isEmpty) {
      otpError.value = 'Please enter verification code';
      return;
    }
    
    if (otp.length < 6) {
      otpError.value = 'Please enter all 6 digits';
      return;
    }
    
    isLoading.value = true;
    try {
      final result = await authService.verifyOTPAndSignIn(otp);
      if (result != null) {
        Get.offAllNamed('/home');
      } else {
        otpError.value = 'Invalid verification code. Please try again.';
      }
    } catch (e) {
      debugPrint('OTP verification error: $e');
      otpError.value = 'Verification failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
} 