import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();
  
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // For backward compatibility
  final RxString name = "Loading...".obs;
  final RxString email = "Loading...".obs;
  final RxString profileImage = "assets/images/default_profile.png".obs;
  
  // User addresses
  final RxList<Map<String, String>> addresses = <Map<String, String>>[].obs;
  
  // Order history
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  
  // Notification settings
  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = true.obs;
  final RxBool orderUpdates = true.obs;
  final RxBool promotions = false.obs;
  
  // Privacy settings
  final RxBool shareData = false.obs;
  final RxBool storePaymentInfo = true.obs;
  final RxBool allowLocationAccess = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }
  
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get the current user ID from AuthService
      final userId = _authService.currentUser.value?.uid;
      
      if (userId == null) {
        errorMessage.value = 'No user is signed in';
        return;
      }
      
      // Get user data from Firestore
      final userData = await _firestoreService.getUser(userId);
      
      if (userData != null) {
        currentUser.value = userData;
        
        // Update the observable variables for backward compatibility
        name.value = userData.displayName;
        email.value = userData.email;
        if (userData.photoURL != null) {
          profileImage.value = userData.photoURL!;
        }
        
        // Load addresses from userData if available
        if (userData.address.isNotEmpty) {
          final defaultAddress = <String, String>{
            'id': '1',
            'title': 'Home',
            'address': userData.address['street']?.toString() ?? '',
            'city': userData.address['city']?.toString() ?? '',
            'state': userData.address['state']?.toString() ?? '',
            'zipCode': userData.address['zipCode']?.toString() ?? '',
            'country': userData.address['country']?.toString() ?? '',
            'isDefault': 'true',
          };
          addresses.clear();
          addresses.add(defaultAddress);
        }
        
        // Load orders
        _loadUserOrders(userId);
      } else {
        errorMessage.value = 'User profile not found';
      }
    } catch (e) {
      errorMessage.value = 'Error loading profile: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _loadUserOrders(String userId) async {
    try {
      _firestoreService.getUserOrders(userId).listen(
        (ordersList) {
          orders.value = ordersList;
        },
        onError: (error) {
          // Using debugPrint instead of print for logging errors
          debugPrint('Error loading orders: $error');
        }
      );
    } catch (e) {
      // Using debugPrint instead of print for logging errors
      debugPrint('Error subscribing to orders: $e');
    }
  }
  
  void logout() {
    _authService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
  
  // Select and upload profile picture from gallery
  Future<void> pickProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        isLoading.value = true;
        
        // Upload image to Firebase Storage
        final imageUrl = await _uploadProfileImage(File(image.path));
        
        if (imageUrl != null) {
          // Update user profile with new image URL
          await updateProfile(newImage: imageUrl);
        }
      }
    } catch (e) {
      errorMessage.value = 'Error picking image: $e';
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Take profile picture from camera
  Future<void> takeProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        isLoading.value = true;
        
        // Upload image to Firebase Storage
        final imageUrl = await _uploadProfileImage(File(image.path));
        
        if (imageUrl != null) {
          // Update user profile with new image URL
          await updateProfile(newImage: imageUrl);
        }
      }
    } catch (e) {
      errorMessage.value = 'Error taking photo: $e';
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final userId = _authService.currentUser.value?.uid;
      if (userId == null) return null;
      
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child('$userId.jpg');
      
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      errorMessage.value = 'Error uploading image: $e';
      Get.snackbar(
        'Upload Failed',
        'Could not upload profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  Future<void> updateProfile({String? newName, String? newEmail, String? newImage}) async {
    try {
      isLoading.value = true;
      
      final userId = _authService.currentUser.value?.uid;
      if (userId == null) {
        errorMessage.value = 'No user is signed in';
        return;
      }
      
      final updates = <String, dynamic>{};
      
      if (newName != null && newName.isNotEmpty) {
        updates['displayName'] = newName;
        name.value = newName;
      }
      
      if (newEmail != null && newEmail.isNotEmpty) {
        // Email update requires auth update and verification
        // Here we're just updating the display value
        email.value = newEmail;
      }
      
      if (newImage != null && newImage.isNotEmpty) {
        updates['photoURL'] = newImage;
        profileImage.value = newImage;
      }
      
      if (updates.isNotEmpty) {
        await _firestoreService.updateUserProfile(userId, updates);
        
        Get.snackbar(
          'Profile Updated',
          'Your profile has been updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Reload the user profile to get the latest data
        await loadUserProfile();
      }
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      Get.snackbar(
        'Update Failed',
        'Could not update your profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updateAddress(String id, Map<String, String> updatedAddress) async {
    try {
      isLoading.value = true;
      
      final userId = _authService.currentUser.value?.uid;
      if (userId == null) {
        errorMessage.value = 'No user is signed in';
        return;
      }
      
      // Update the local addresses list
      final index = addresses.indexWhere((address) => address['id'] == id);
      if (index != -1) {
        addresses[index] = updatedAddress;
      }
      
      // Update the address in Firestore
      final address = <String, dynamic>{
        'street': updatedAddress['address'],
        'city': updatedAddress['city'],
        'state': updatedAddress['state'],
        'zipCode': updatedAddress['zipCode'],
        'country': updatedAddress['country'] ?? 'USA',
      };
      
      await _firestoreService.updateUserProfile(userId, {'address': address});
      
      Get.back();
      Get.snackbar(
        'Address Updated',
        'Your address has been updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Reload user profile
      await loadUserProfile();
    } catch (e) {
      errorMessage.value = 'Error updating address: $e';
      Get.snackbar(
        'Update Failed',
        'Could not update your address: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void addAddress(Map<String, String> address) {
    final newId = (addresses.length + 1).toString();
    final newAddress = {...address, 'id': newId};
    addresses.add(newAddress);
    
    // If this is the first address, make it the default
    if (addresses.length == 1) {
      newAddress['isDefault'] = 'true';
    }
    
    // Save to Firestore
    updateAddress(newId, newAddress);
    
    Get.back();
    Get.snackbar(
      'Address Added',
      'New address has been added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void deleteAddress(String id) {
    addresses.removeWhere((address) => address['id'] == id);
    
    // If we have other addresses and deleted the default one, make the first one the default
    if (addresses.isNotEmpty && !addresses.any((address) => address['isDefault'] == 'true')) {
      addresses[0]['isDefault'] = 'true';
    }
    
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