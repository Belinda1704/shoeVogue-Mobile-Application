import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/payment_service.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  final paymentService = Get.find<PaymentService>();
  
  // Form controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Observable values for country and phone
  final country = 'United States'.obs;
  final phoneNumber = ''.obs;
  
  // Loading state
  final isLoading = false.obs;
  
  // Selected payment method
  final paymentMethod = 'card'.obs;  // Default to card payment
  
  // Mock values - replace with actual cart values
  final subtotal = 99.99.obs;
  final shipping = 10.00.obs;
  final tax = 8.00.obs;
  final total = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Calculate total
    total.value = subtotal.value + shipping.value + tax.value;
  }
  
  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        zipController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
  
  void handlePayment() async {
    if (!_validateForm()) return;

    final orderDetails = {
      'name': nameController.text,
      'address': addressController.text,
      'city': cityController.text,
      'zipCode': zipController.text,
      'phone': phoneController.text,
      'items': [], // Replace with actual cart items
      'subtotal': subtotal.value,
      'shipping': shipping.value,
      'tax': tax.value,
      'total': total.value,
    };

    await paymentService.processPayment(
      paymentMethod: paymentMethod.value,
      amount: total.value,
      currency: 'USD',
      orderDetails: orderDetails,
      onSuccess: () {
        // Clear form
        nameController.clear();
        addressController.clear();
        cityController.clear();
        zipController.clear();
        phoneController.clear();
        
        // Navigate to order success
        Get.offAllNamed(Routes.ORDER_SUCCESS);
      },
      onError: (error) {
        Get.log('Payment error: $error');
      },
    );
  }
} 