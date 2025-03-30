import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class NotificationsView extends GetView<ProfileController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'notification_settings'.tr,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Push notifications
            _buildNotificationOption(
              context,
              'push_notifications'.tr,
              'push_notifications_desc'.tr,
              controller.isPushNotificationsEnabled,
              (value) => controller.togglePushNotifications(value),
            ),
            
            const Divider(),
            
            // Email notifications
            _buildNotificationOption(
              context,
              'email_notifications'.tr,
              'email_notifications_desc'.tr,
              controller.isEmailNotificationsEnabled,
              (value) => controller.toggleEmailNotifications(value),
            ),
            
            const Divider(),
            
            // Notification categories
            const SizedBox(height: 16),
            Text(
              'notification_categories'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            _buildNotificationCategory(
              context,
              'order_updates'.tr,
              Icons.local_shipping,
            ),
            
            _buildNotificationCategory(
              context,
              'promotions'.tr,
              Icons.discount,
            ),
            
            _buildNotificationCategory(
              context,
              'new_arrivals'.tr,
              Icons.new_releases,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption(
    BuildContext context,
    String title,
    String description,
    RxBool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: value.value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          )),
        ],
      ),
    );
  }

  Widget _buildNotificationCategory(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      trailing: Obx(() => Checkbox(
        value: controller.isPushNotificationsEnabled.value,
        onChanged: (val) {
          if (val != null) {
            controller.togglePushNotifications(val);
          }
        },
        activeColor: Theme.of(context).colorScheme.primary,
      )),
    );
  }
} 