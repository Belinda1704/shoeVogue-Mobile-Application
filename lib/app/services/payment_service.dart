import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService extends GetxService {
  static PaymentService get to => Get.find();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<PaymentService> init() async {
    // Initialize any required resources here
    return this;
  }

  Future<void> processPayment({
    required String paymentMethod,
    required double amount,
    required String currency,
    required Map<String, dynamic> orderDetails,
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Process payment based on method
      switch (paymentMethod) {
        case 'card':
          await _processCardPayment(amount, currency, orderDetails);
          break;
        case 'google_pay':
          await _processGooglePayPayment(amount, currency);
          break;
        case 'apple_pay':
          await _processApplePayPayment(amount, currency);
          break;
        case 'paypal':
          await _processPayPalPayment(amount, currency);
          break;
        case 'cash':
          await _processCashOnDelivery(amount, orderDetails);
          break;
        default:
          throw 'Unsupported payment method';
      }

      // Save order to Firestore
      await _saveOrder(orderDetails, paymentMethod);
      
      // Close loading dialog
      Get.back();

      // Show success dialog
      await Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/successful-payment-icon.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Amount paid: ${currency.toUpperCase()} ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onSuccess(); // Call success callback
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      // Show error message
      Get.snackbar(
        'Error',
        'Payment failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      // Call error callback
      onError(e);
    }
  }

  Future<void> _processCardPayment(double amount, String currency, Map<String, dynamic> orderDetails) async {
    // In production, integrate with a payment gateway
    // For now, we'll simulate card payment processing
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _processGooglePayPayment(double amount, String currency) async {
    // In production, integrate with Google Pay API
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _processApplePayPayment(double amount, String currency) async {
    // In production, integrate with Apple Pay API
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _processPayPalPayment(double amount, String currency) async {
    // In production, integrate with PayPal SDK
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _processCashOnDelivery(double amount, Map<String, dynamic> orderDetails) async {
    // Validate delivery address
    if (orderDetails['address'] == null || orderDetails['address'].toString().isEmpty) {
      throw 'Delivery address is required for Cash on Delivery';
    }
    
    // Validate phone number
    if (orderDetails['phone'] == null || orderDetails['phone'].toString().isEmpty) {
      throw 'Phone number is required for Cash on Delivery';
    }
  }

  Future<void> _saveOrder(Map<String, dynamic> orderDetails, String paymentMethod) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw 'User not authenticated';

    // Add payment method and status to order details
    orderDetails['paymentMethod'] = paymentMethod;
    orderDetails['status'] = _getOrderStatus(paymentMethod);
    orderDetails['createdAt'] = FieldValue.serverTimestamp();
    orderDetails['userId'] = userId;

    // Save to orders collection
    await _firestore.collection('orders').add(orderDetails);

    // Clear user's cart
    await _firestore.collection('cart').doc(userId).update({
      'items': [],
      'estimatedTotal': 0.0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _getOrderStatus(String paymentMethod) {
    switch (paymentMethod) {
      case 'cash':
        return 'pending';
      case 'card':
      case 'google_pay':
      case 'apple_pay':
      case 'paypal':
        return 'paid';
      default:
        return 'pending';
    }
  }
} 