import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../services/auth_service.dart';

class PhoneAuthView extends GetView {
  const PhoneAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneAuthViewController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Enter your phone number',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We will send you a verification code to verify your identity.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              // Phone number field
              Obx(() => IntlPhoneField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabled: !controller.isLoading.value,
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  controller.completePhoneNumber.value = phone.completeNumber;
                },
              )),
              const SizedBox(height: 8),
              // Number format guide
              Text(
                'Include your country code and full phone number',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              // Send OTP button
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.sendOTP(),
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
                            'Sending...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Send Verification Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
              const SizedBox(height: 40),
              // Loading indicator during verification
              Obx(() => controller.isLoading.value
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Verifying phone number...',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You may see a reCAPTCHA verification screen',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 20),
              // Back button
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneAuthViewController extends GetxController {
  final phoneController = TextEditingController();
  final completePhoneNumber = ''.obs;
  final isLoading = false.obs;
  final authService = Get.find<AuthService>();
  
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
  
  void sendOTP() async {
    if (completePhoneNumber.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isLoading.value = true;
    try {
      await authService.verifyPhoneNumber(completePhoneNumber.value);
    } catch (e) {
      print('Error in view controller: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 