import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final RxString name = "John Doe".obs;
  final RxString email = "john.doe@example.com".obs;
  final RxString profileImage = "assets/images/default_profile.png".obs;
  
  // User addresses
  final RxList<Map<String, String>> addresses = <Map<String, String>>[
    {
      'id': '1',
      'title': 'Home',
      'address': '123 Main Street, Apt 4B',
      'city': 'New York',
      'state': 'NY',
      'zipCode': '10001',
      'isDefault': 'true',
    },
    {
      'id': '2',
      'title': 'Work',
      'address': '456 Office Plaza, Suite 200',
      'city': 'New York',
      'state': 'NY',
      'zipCode': '10002',
      'isDefault': 'false',
    },
  ].obs;
  
  // Order history
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      'id': 'ORD-001',
      'date': '2023-03-15',
      'status': 'Delivered',
      'total': 259.98,
      'items': [
        {
          'name': 'Nike Air Jordan Orange',
          'price': 199.99,
          'quantity': 1,
        },
        {
          'name': 'Adidas Samba',
          'price': 59.99,
          'quantity': 1,
        },
      ],
    },
    {
      'id': 'ORD-002',
      'date': '2023-02-28',
      'status': 'Processing',
      'total': 399.99,
      'items': [
        {
          'name': 'Prada Leather',
          'price': 399.99,
          'quantity': 1,
        },
      ],
    },
  ].obs;
  
  // Notification settings
  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = true.obs;
  final RxBool orderUpdates = true.obs;
  final RxBool promotions = false.obs;
  
  // Privacy settings
  final RxBool shareData = false.obs;
  final RxBool storePaymentInfo = true.obs;
  final RxBool allowLocationAccess = true.obs;
  
  void logout() {
    // Here you would implement actual logout logic
    Get.offAllNamed(Routes.ONBOARDING);
  }
  
  void updateProfile({String? newName, String? newEmail, String? newImage}) {
    if (newName != null) name.value = newName;
    if (newEmail != null) email.value = newEmail;
    if (newImage != null) profileImage.value = newImage;
    
    Get.snackbar(
      'Profile Updated',
      'Your profile has been updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void addAddress(Map<String, String> address) {
    addresses.add(address);
    Get.back();
    Get.snackbar(
      'Address Added',
      'New address has been added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void updateAddress(String id, Map<String, String> updatedAddress) {
    final index = addresses.indexWhere((address) => address['id'] == id);
    if (index != -1) {
      addresses[index] = updatedAddress;
      Get.back();
      Get.snackbar(
        'Address Updated',
        'Your address has been updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void deleteAddress(String id) {
    addresses.removeWhere((address) => address['id'] == id);
    Get.snackbar(
      'Address Removed',
      'Address has been removed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void toggleNotificationSetting(String setting, bool value) {
    switch (setting) {
      case 'push':
        pushNotifications.value = value;
        break;
      case 'email':
        emailNotifications.value = value;
        break;
      case 'orders':
        orderUpdates.value = value;
        break;
      case 'promotions':
        promotions.value = value;
        break;
    }
    
    Get.snackbar(
      'Settings Updated',
      'Your notification preferences have been updated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void togglePrivacySetting(String setting, bool value) {
    switch (setting) {
      case 'shareData':
        shareData.value = value;
        break;
      case 'storePaymentInfo':
        storePaymentInfo.value = value;
        break;
      case 'allowLocationAccess':
        allowLocationAccess.value = value;
        break;
    }
    
    Get.snackbar(
      'Privacy Updated',
      'Your privacy settings have been updated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} 