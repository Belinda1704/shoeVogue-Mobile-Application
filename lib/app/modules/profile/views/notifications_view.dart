import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class NotificationsView extends GetView<ProfileController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Push notifications
            Obx(() => SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive alerts on your device'),
              value: controller.pushNotifications.value,
              onChanged: (value) => controller.toggleNotificationSetting('push', value),
              activeColor: Colors.blue,
            )),
            
            const Divider(),
            
            // Email notifications
            Obx(() => SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive alerts via email'),
              value: controller.emailNotifications.value,
              onChanged: (value) => controller.toggleNotificationSetting('email', value),
              activeColor: Colors.blue,
            )),
            
            const Divider(),
            
            // Order updates
            Obx(() => SwitchListTile(
              title: const Text('Order Updates'),
              subtitle: const Text('Get notified about order status changes'),
              value: controller.orderUpdates.value,
              onChanged: (value) => controller.toggleNotificationSetting('orders', value),
              activeColor: Colors.blue,
            )),
            
            const Divider(),
            
            // Promotions
            Obx(() => SwitchListTile(
              title: const Text('Promotions & Deals'),
              subtitle: const Text('Receive information about sales and offers'),
              value: controller.promotions.value,
              onChanged: (value) => controller.toggleNotificationSetting('promotions', value),
              activeColor: Colors.blue,
            )),
            
            const SizedBox(height: 32),
            const Text(
              'Notification History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Your order has been shipped!'),
                subtitle: const Text('Order #ORD-001 is on its way to you.'),
                trailing: const Text('2 hours ago'),
                onTap: () {},
              ),
            ),
            
            const SizedBox(height: 8),
            
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Payment successful'),
                subtitle: const Text('Your payment for order #ORD-002 was successful.'),
                trailing: const Text('Yesterday'),
                onTap: () {},
              ),
            ),
            
            const SizedBox(height: 8),
            
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.discount,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Flash Sale! 25% Off'),
                subtitle: const Text('Get 25% off on all Nike products for 24 hours!'),
                trailing: const Text('2 days ago'),
                onTap: () {},
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
} 