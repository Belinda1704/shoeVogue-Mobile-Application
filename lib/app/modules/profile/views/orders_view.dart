import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersView extends GetView<ProfileController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Start Shopping'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            
            // Safely handle the date formatting
            String formattedDate;
            try {
              // Check if date exists and is in the correct format
              if (order['date'] != null) {
                formattedDate = DateFormat('MMM dd, yyyy').format(
                  DateTime.parse(order['date'].toString()),
                );
              } else if (order['createdAt'] != null) {
                // Try to use createdAt timestamp if date is missing
                final Timestamp timestamp = order['createdAt'] as Timestamp;
                formattedDate = DateFormat('MMM dd, yyyy').format(timestamp.toDate());
              } else {
                // Fallback if no valid date is found
                formattedDate = 'N/A';
              }
            } catch (e) {
              debugPrint('Error formatting date: $e');
              formattedDate = 'N/A';
            }
            
            // Safely format the total
            String formattedTotal;
            try {
              final total = order['total'] ?? order['totalAmount'] ?? 0.0;
              formattedTotal = NumberFormat.currency(
                symbol: '\$',
                decimalDigits: 2,
              ).format(total);
            } catch (e) {
              debugPrint('Error formatting total: $e');
              formattedTotal = '\$0.00';
            }
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Order header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${order['id']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Order items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (order['items'] as List?)?.length ?? 0,
                    itemBuilder: (context, itemIndex) {
                      try {
                        final items = order['items'] as List?;
                        if (items == null || items.isEmpty || itemIndex >= items.length) {
                          return const ListTile(
                            title: Text('Unknown item'),
                            subtitle: Text('No details available'),
                          );
                        }
                        
                        final item = items[itemIndex];
                        if (item == null) {
                          return const ListTile(
                            title: Text('Unknown item'),
                            subtitle: Text('No details available'),
                          );
                        }
                        
                        final String name = item['name']?.toString() ?? 'Unknown item';
                        final int quantity = item['quantity'] is int ? item['quantity'] : 1;
                        final double price = (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0;
                        final double itemTotal = price * quantity;
                        
                        final formattedItemTotal = NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(itemTotal);
                        
                        return ListTile(
                          title: Text(name),
                          subtitle: Text('Qty: $quantity'),
                          trailing: Text(formattedItemTotal),
                        );
                      } catch (e) {
                        debugPrint('Error rendering order item: $e');
                        return const ListTile(
                          title: Text('Error'),
                          subtitle: Text('Could not load item details'),
                        );
                      }
                    },
                  ),
                  
                  // Order footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order['status']?.toString() ?? 'pending'),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            (order['status']?.toString() ?? 'Pending').capitalize!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              formattedTotal,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'processing': 
      case 'processed':
        return Colors.orange;
      case 'shipped':
      case 'shipping':
        return Colors.blue;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      case 'pending':
      case 'paid':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
} 