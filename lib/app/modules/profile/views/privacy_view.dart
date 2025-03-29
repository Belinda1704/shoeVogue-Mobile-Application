import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class PrivacyView extends GetView<ProfileController> {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Control how your information is used and shared.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Data sharing
            Obx(() => SwitchListTile(
              title: const Text('Share Usage Data'),
              subtitle: const Text('Allow us to collect data to improve your experience'),
              value: controller.shareData.value,
              onChanged: (value) => controller.togglePrivacySetting('shareData', value),
              activeColor: Colors.blue,
            )),
            
            const Divider(),
            
            // Payment info
            Obx(() => SwitchListTile(
              title: const Text('Store Payment Information'),
              subtitle: const Text('Securely save your payment details for future purchases'),
              value: controller.storePaymentInfo.value,
              onChanged: (value) => controller.togglePrivacySetting('storePaymentInfo', value),
              activeColor: Colors.blue,
            )),
            
            const Divider(),
            
            // Location access
            Obx(() => SwitchListTile(
              title: const Text('Location Access'),
              subtitle: const Text('Allow access to your location for better recommendations'),
              value: controller.allowLocationAccess.value,
              onChanged: (value) => controller.togglePrivacySetting('allowLocationAccess', value),
              activeColor: Colors.blue,
            )),
            
            const SizedBox(height: 32),
            
            const Text(
              'Account Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.snackbar(
                  'Feature Coming Soon',
                  'Password change functionality will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Two-Factor Authentication'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.snackbar(
                  'Feature Coming Soon',
                  'Two-factor authentication will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Login Activity'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.snackbar(
                  'Feature Coming Soon',
                  'Login activity tracking will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Privacy policy
            Center(
              child: TextButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Privacy Policy'),
                      content: SingleChildScrollView(
                        child: Text(
                          'This is a sample privacy policy for the ShoeApp. '
                          'In a real application, this would contain detailed information '
                          'about how user data is collected, stored, and processed. '
                          '\n\nEffective Date: January 1, 2023',
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
                child: const Text('View Privacy Policy'),
              ),
            ),
            
            Center(
              child: TextButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text(
                        'Are you sure you want to delete your account? '
                        'This action cannot be undone and all your data will be permanently removed.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.snackbar(
                              'Account Deletion',
                              'This feature is not implemented in the demo',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete My Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 