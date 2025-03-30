import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../theme/app_theme.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  // Helper method to format currency
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeController = Get.find<HomeController>();
    
    return WillPopScope(
      onWillPop: () async {
        // Navigate to home tab using HomeController
        homeController.changePage(0);
        Get.back();
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
          backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to home tab using HomeController
              homeController.changePage(0);
              Get.back();
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                    size: 100,
                  color: Colors.grey[400],
                ),
                  const SizedBox(height: 24),
                Text(
                  'cart_empty'.tr,
                    style: theme.textTheme.headlineMedium,
                ),
                  const SizedBox(height: 12),
                Text(
                  'add_items_to_cart'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                  const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: () {
                      // Navigate to home tab using HomeController
                      homeController.changePage(0);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'continue_shopping'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Product Image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: AppTheme.lightBlue,
                              borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                                  item['imageUrl'] ?? 'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ),
                          const SizedBox(width: 16),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    item['name'] ?? 'Unknown Product',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Add size and color if available
                                  if (item['size'] != null) 
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'size'.tr + ': ' + item['size'].toString(),
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  if (item['color'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'color'.tr + ': ',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: item['color'].toString().startsWith('#') ? 
                                                Color(int.parse(item['color'].substring(1), radix: 16) + 0xFF000000) : 
                                                Colors.grey,
                                              borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                                  const SizedBox(height: 8),
                          Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                        formatCurrency((item['price'] ?? 0.0) * (item['quantity'] ?? 1)),
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                                      // Quantity controls
                                      Row(
                                        children: [
                                          // Decrease quantity
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.remove, size: 18),
                                              onPressed: () => controller.decreaseQuantity(index),
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          // Quantity display
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              '${item['quantity'] ?? 1}',
                                              style: theme.textTheme.titleLarge,
                                            ),
                                          ),
                                          // Increase quantity
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryBlue,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.add, size: 18, color: Colors.white),
                                              onPressed: () => controller.increaseQuantity(index),
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
              
              // Checkout section at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'subtotal'.tr,
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          formatCurrency(controller.subtotal),
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'shipping'.tr,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          formatCurrency(controller.shippingCost),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total'.tr,
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          formatCurrency(controller.total),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'proceed_to_checkout'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
      ),
    );
  }
} 