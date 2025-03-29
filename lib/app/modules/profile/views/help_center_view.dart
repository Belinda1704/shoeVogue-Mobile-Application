import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenterView extends GetView {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for help',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onSubmitted: (value) {
                Get.snackbar(
                  'Search',
                  'Searching for "$value"',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildFaqItem(
              'How do I track my order?',
              'You can track your order by going to the "Orders" section in your profile and '
              'selecting the order you want to track. There you will find the current status '
              'and tracking information for your order.',
            ),
            
            _buildFaqItem(
              'What is your return policy?',
              'We offer a 30-day return policy for all unworn items in their original packaging. '
              'To initiate a return, go to your order history, select the item you wish to return, '
              'and follow the return instructions.',
            ),
            
            _buildFaqItem(
              'How do I change my shipping address?',
              'You can update your shipping address in the "Addresses" section of your profile. '
              'If you need to change the address for a specific order that has not yet shipped, '
              'please contact customer support immediately.',
            ),
            
            _buildFaqItem(
              'Do you ship internationally?',
              'Yes, we ship to many countries worldwide. Shipping rates and delivery times vary '
              'depending on the destination. You can see the shipping options during checkout.',
            ),
            
            _buildFaqItem(
              'How do I apply a discount code?',
              'During checkout, you will find a field labeled "Discount Code" where you can enter '
              'your code. Click "Apply" to see the discount reflected in your order total.',
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Contact options
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Live Chat'),
                subtitle: const Text('Talk to our support team'),
                onTap: () {
                  Get.snackbar(
                    'Live Chat',
                    'This feature is not implemented in the demo',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Email Support'),
                subtitle: const Text('support@shoeapp.com'),
                onTap: () {
                  Get.snackbar(
                    'Email Support',
                    'This feature is not implemented in the demo',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Call Us'),
                subtitle: const Text('1-800-SHOE-APP (250-788-880-888)'),
                onTap: () {
                  Get.snackbar(
                    'Call Support',
                    'This feature is not implemented in the demo',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
} 