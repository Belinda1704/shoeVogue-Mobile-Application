import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
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
                    _buildSectionTitle('Shipping Address'),
                    const SizedBox(height: 16),
                    _buildShippingAddressCard(context),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Method Section
                    _buildSectionTitle('Payment Method'),
                    const SizedBox(height: 16),
                    _buildPaymentMethodCard(context),
                    
                    const SizedBox(height: 24),
                    
                    // Order Summary Section
                    _buildSectionTitle('Order Summary'),
                    const SizedBox(height: 16),
                    _buildOrderSummaryCard(context),
                    
                    const SizedBox(height: 32),
                    
                    // Pay Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            controller.handlePayment();
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'There was a problem processing your payment. Please try again.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 4),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildShippingAddressCard(BuildContext context) {
    // List of countries for dropdown
    const List<String> countries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'Germany',
      'France',
      'Spain',
      'Italy',
      'Japan',
      'China',
      'India',
      'Brazil',
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name field
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Country dropdown
            DropdownButtonFormField<String>(
              value: controller.country.value.isEmpty ? countries[0] : controller.country.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.country.value = newValue;
                }
              },
              items: countries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Country',
                prefixIcon: const Icon(Icons.public),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Street Address field
            TextFormField(
              controller: controller.addressController,
              decoration: InputDecoration(
                labelText: 'Street Address',
                prefixIcon: const Icon(Icons.home_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // City and ZIP fields in a row
            Row(
              children: [
                // City field
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: controller.cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // ZIP Code field
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: controller.zipController,
                    decoration: InputDecoration(
                      labelText: 'ZIP Code',
                      prefixIcon: const Icon(Icons.markunread_mailbox_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Phone Number field with country code
            IntlPhoneField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              initialCountryCode: 'US',
              onChanged: (phone) {
                controller.phoneNumber.value = phone.completeNumber;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPaymentMethodTile(
              context: context,
              title: 'Credit/Debit Card',
              subtitle: 'Pay with Visa, Mastercard',
              value: 'card',
              iconPath: 'assets/icons/payment_methods/credit-card.png',
            ),
            const Divider(height: 1),
            _buildPaymentMethodTile(
              context: context,
              title: 'Google Pay',
              subtitle: 'Fast and secure payment',
              value: 'google_pay',
              iconPath: 'assets/icons/payment_methods/google-pay.png',
            ),
            const Divider(height: 1),
            _buildPaymentMethodTile(
              context: context,
              title: 'Apple Pay',
              subtitle: 'Quick and secure checkout',
              value: 'apple_pay',
              iconPath: 'assets/icons/payment_methods/apple-pay.png',
            ),
            const Divider(height: 1),
            _buildPaymentMethodTile(
              context: context,
              title: 'PayPal',
              subtitle: 'Pay with PayPal account',
              value: 'paypal',
              iconPath: 'assets/icons/payment_methods/paypal.png',
            ),
            const Divider(height: 1),
            _buildPaymentMethodTile(
              context: context,
              title: 'Cash on Delivery',
              subtitle: 'Pay when you receive',
              value: 'cash',
              iconPath: 'assets/icons/payment_methods/credit-card.png', // Replace with cash icon when available
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String value,
    required String iconPath,
  }) {
    return Obx(() => InkWell(
      onTap: () => controller.paymentMethod.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16),
              child: Image.asset(
                iconPath,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback icon if image fails to load
                  return Icon(
                    Icons.payment,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: controller.paymentMethod.value,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.paymentMethod.value = newValue;
                }
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildOrderSummaryCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', controller.subtotal, context),
            const SizedBox(height: 12),
            _buildSummaryRow('Shipping', controller.shipping, context),
            const SizedBox(height: 12),
            _buildSummaryRow('Tax', controller.tax, context),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _buildSummaryRow(
              'Total',
              controller.total,
              context,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    RxDouble amount,
    BuildContext context, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
        Obx(() => Text(
          '\$${amount.value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Theme.of(context).primaryColor : Colors.black87,
          ),
        )),
      ],
    );
  }
} 