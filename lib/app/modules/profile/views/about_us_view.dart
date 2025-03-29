import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsView extends GetView {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ShoeVogue',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Our Story',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'ShoeVogue was founded in 2025 with a simple mission: to provide high-quality, '
              'stylish footwear at affordable prices. We believe that everyone deserves to '
              'look and feel their best, and our curated collection of shoes helps our customers '
              'do just that.\n\n'
              'What started as a small passion project has grown into a thriving online '
              'marketplace, serving customers all over the world. We\'re proud of our journey '
              'and excited for what the future holds.',
              style: TextStyle(
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Our Values',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildValueItem(
              Icons.check_circle,
              'Quality',
              'We source only the best materials and products for our customers.',
            ),
            
            _buildValueItem(
              Icons.people,
              'Community',
              'We believe in building lasting relationships with our customers and partners.',
            ),
            
            _buildValueItem(
              Icons.eco,
              'Sustainability',
              'We are committed to reducing our environmental impact through eco-friendly practices.',
            ),
            
            _buildValueItem(
              Icons.handshake,
              'Integrity',
              'We operate with honesty and transparency in all that we do.',
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Connect With Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(Icons.facebook, Colors.blue.shade800),
                _buildSocialButton(Icons.camera_alt, Colors.purple),
                _buildSocialButton(Icons.message, Colors.blue),
                _buildSocialButton(Icons.video_call, Colors.red),
              ],
            ),
            
            const SizedBox(height: 32),
            
            Center(
              child: TextButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Terms & Conditions'),
                      content: SingleChildScrollView(
                        child: Text(
                          'This is a sample terms and conditions for the ShoeApp. '
                          'In a real application, this would contain detailed information '
                          'about the terms of service, user agreements, and legal notices. '
                          '\n\nLast Updated: April 1, 2025',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Terms & Conditions'),
              ),
            ),
            
            Center(
              child: Text(
                '© 2025 ShoeApp. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: color,
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: () {
            Get.snackbar(
              'Social Media',
              'This feature is not implemented in the demo',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
    );
  }
} 