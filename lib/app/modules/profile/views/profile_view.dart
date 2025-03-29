import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';
import 'addresses_view.dart';
import 'orders_view.dart';
import 'notifications_view.dart';
import 'privacy_view.dart';
import 'help_center_view.dart';
import 'about_us_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadUserProfile(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // Profile image
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage: (controller.currentUser.value?.photoURL != null && 
                               controller.currentUser.value!.photoURL!.isNotEmpty)
                          ? NetworkImage(controller.currentUser.value!.photoURL!)
                          : null,
                      child: (controller.currentUser.value?.photoURL == null || 
                              controller.currentUser.value!.photoURL!.isEmpty)
                          ? Text(
                              controller.name.value.isNotEmpty
                                  ? controller.name.value[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.grey[900] : Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Name
                    Text(
                      controller.name.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Email
                    Text(
                      controller.email.value,
                      style: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    
                    // Phone number (if available)
                    if (controller.currentUser.value?.phoneNumber != null &&
                        controller.currentUser.value!.phoneNumber!.isNotEmpty)
                      Text(
                        controller.currentUser.value!.phoneNumber!,
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Account Settings
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'account_settings'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('edit_profile'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const EditProfileView()),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('my_addresses'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const AddressesView()),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag_outlined,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('my_orders'.tr),
                      subtitle: Text(
                        '${controller.orders.length} ${controller.orders.length == 1 ? 'order'.tr : 'orders'.tr}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const OrdersView()),
                    ),
                  ],
                ),
              ),
              
              // Address information (if available)
              if (controller.addresses.isNotEmpty || 
                  (controller.currentUser.value?.address != null && 
                   controller.currentUser.value!.address.isNotEmpty))
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.grey.shade200,
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'address'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildAddressInfo(isDark),
                      ),
                    ],
                  ),
                ),
              
              // Preferences
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'preferences'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications_none,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('notifications'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const NotificationsView()),
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip_outlined,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('privacy_policy'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const PrivacyView()),
                    ),
                  ],
                ),
              ),
              
              // Support
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'support'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('help_center'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const HelpCenterView()),
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline,
                          color: isDark ? Colors.grey[300] : null),
                      title: Text('about_us'.tr),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: isDark ? Colors.grey[300] : null),
                      onTap: () => Get.to(() => const AboutUsView()),
                    ),
                  ],
                ),
              ),
              
              // Logout Button
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'log_out'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildAddressInfo(bool isDark) {
    String addressText = '';
    
    if (controller.addresses.isNotEmpty) {
      final defaultAddress = controller.addresses.firstWhere(
        (a) => a['isDefault'] == 'true', 
        orElse: () => controller.addresses.first,
      );
      
      final parts = [
        defaultAddress['address'],
        defaultAddress['city'],
        defaultAddress['state'],
        defaultAddress['zipCode'],
        defaultAddress['country'],
      ].where((part) => part != null && part.isNotEmpty).toList();
      
      addressText = parts.join(', ');
    } else if (controller.currentUser.value?.address != null) {
      final address = controller.currentUser.value!.address;
      final parts = [
        address['street'],
        address['city'],
        address['state'],
        address['zipCode'],
        address['country'],
      ].where((part) => part != null && part.isNotEmpty).toList();
      
      addressText = parts.join(', ');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.home,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.addresses.isNotEmpty
                        ? (controller.addresses.firstWhere(
                            (a) => a['isDefault'] == 'true',
                            orElse: () => controller.addresses.first,
                          )['title'] ?? 'Home')
                        : 'Home',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    addressText,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
} 