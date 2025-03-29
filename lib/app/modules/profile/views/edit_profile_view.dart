import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // Show loading indicator while loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Show error message if there's an error
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
        
        // Create controllers with current values
        final nameController = TextEditingController(text: controller.name.value);
        final emailController = TextEditingController(text: controller.email.value);
        
        // Phone number field
        final phoneController = TextEditingController(
          text: controller.currentUser.value?.phoneNumber ?? '',
        );
        
        // Address fields
        String street = '';
        String city = '';
        String state = '';
        String zipCode = '';
        String country = '';
        
        if (controller.addresses.isNotEmpty) {
          final defaultAddress = controller.addresses.firstWhere(
            (a) => a['isDefault'] == 'true',
            orElse: () => controller.addresses.first,
          );
          
          street = defaultAddress['address'] ?? '';
          city = defaultAddress['city'] ?? '';
          state = defaultAddress['state'] ?? '';
          zipCode = defaultAddress['zipCode'] ?? '';
          country = defaultAddress['country'] ?? '';
        } else if (controller.currentUser.value?.address != null) {
          final address = controller.currentUser.value!.address;
          street = address['street']?.toString() ?? '';
          city = address['city']?.toString() ?? '';
          state = address['state']?.toString() ?? '';
          zipCode = address['zipCode']?.toString() ?? '';
          country = address['country']?.toString() ?? '';
        }
        
        final streetController = TextEditingController(text: street);
        final cityController = TextEditingController(text: city);
        final stateController = TextEditingController(text: state);
        final zipCodeController = TextEditingController(text: zipCode);
        final countryController = TextEditingController(text: country);
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture
              Center(
                child: Stack(
                  children: [
                    // Profile image
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      backgroundImage: _getProfileImage(),
                      child: (controller.currentUser.value?.photoURL == null || 
                              controller.currentUser.value!.photoURL!.isEmpty)
                          ? Text(
                              controller.name.value.isNotEmpty
                                  ? controller.name.value[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    
                    // Camera button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onSelected: (value) {
                            if (value == 'camera') {
                              controller.takeProfilePicture();
                            } else if (value == 'gallery') {
                              controller.pickProfilePicture();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'camera',
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(width: 8),
                                  Text('Take a photo'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'gallery',
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library),
                                  SizedBox(width: 8),
                                  Text('Choose from gallery'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Personal Information Section
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Name field
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Email field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // Phone field
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 30),
              
              // Address Section
              const Text(
                'Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Street
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // City & State in a row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Zip & Country in a row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Update personal info
                    await controller.updateProfile(
                      newName: nameController.text,
                      newEmail: emailController.text,
                    );
                    
                    // Update address
                    if (controller.addresses.isNotEmpty) {
                      final defaultAddress = controller.addresses.firstWhere(
                        (a) => a['isDefault'] == 'true',
                        orElse: () => controller.addresses.first,
                      );
                      
                      final updatedAddress = {
                        ...defaultAddress,
                        'address': streetController.text,
                        'city': cityController.text,
                        'state': stateController.text,
                        'zipCode': zipCodeController.text,
                        'country': countryController.text,
                      };
                      
                      await controller.updateAddress(defaultAddress['id']!, updatedAddress);
                    } else {
                      // Create a new address
                      final newAddress = {
                        'title': 'Home',
                        'address': streetController.text,
                        'city': cityController.text,
                        'state': stateController.text,
                        'zipCode': zipCodeController.text,
                        'country': countryController.text,
                        'isDefault': 'true',
                      };
                      
                      controller.addAddress(newAddress);
                    }
                    
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
  
  // Helper method to get profile image
  ImageProvider? _getProfileImage() {
    final photoURL = controller.currentUser.value?.photoURL;
    
    if (photoURL != null && photoURL.isNotEmpty) {
      if (photoURL.startsWith('http')) {
        return NetworkImage(photoURL);
      } else {
        return AssetImage(photoURL);
      }
    }
    
    return null;
  }
} 