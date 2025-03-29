import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address Section
                    const Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildShippingAddressCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Method Section
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentMethodCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Order Summary Section
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderSummaryCard(),
                    
                    const SizedBox(height: 32),
                    
                    // Pay Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.handlePayment(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildShippingAddressCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.addressController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPaymentMethodTile(
              title: 'Credit/Debit Card',
              subtitle: 'Pay with Visa, Mastercard',
              value: 'card',
              leadingImages: [
                'assets/icons/payment_methods/visa.png',
                'assets/icons/payment_methods/master-card.png',
              ],
            ),
            const Divider(),
            _buildPaymentMethodTile(
              title: 'Google Pay',
              subtitle: 'Fast and secure payment',
              value: 'google_pay',
              leadingImages: ['assets/icons/payment_methods/google-pay.png'],
            ),
            const Divider(),
            _buildPaymentMethodTile(
              title: 'Apple Pay',
              subtitle: 'Quick and secure checkout',
              value: 'apple_pay',
              leadingImages: ['assets/icons/payment_methods/apple-pay.png'],
            ),
            const Divider(),
            _buildPaymentMethodTile(
              title: 'PayPal',
              subtitle: 'Pay with PayPal account',
              value: 'paypal',
              leadingImages: ['assets/icons/payment_methods/paypal.png'],
            ),
            const Divider(),
            _buildPaymentMethodTile(
              title: 'Cash on Delivery',
              subtitle: 'Pay when you receive',
              value: 'cash',
              leadingImages: ['assets/icons/payment_methods/credit-card.png'],
              iconColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> leadingImages,
    Color? iconColor,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: leadingImages.map((image) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              image,
              width: 32,
              height: 32,
              color: iconColor,
            ),
          );
        }).toList(),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: controller.paymentMethod.value,
        onChanged: (value) => controller.paymentMethod.value = value!,
      ),
      onTap: () => controller.paymentMethod.value = value,
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', controller.subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow('Shipping', controller.shipping),
            const SizedBox(height: 8),
            _buildSummaryRow('Tax', controller.tax),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              controller.total,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, RxDouble value, {bool isTotal = false}) {
    final textStyle = isTotal
        ? const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Obx(() => Text(
              '\$${value.value.toStringAsFixed(2)}',
              style: textStyle,
            )),
      ],
    );
  }
} 