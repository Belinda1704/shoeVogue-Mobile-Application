import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupView extends GetView {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();
    final authService = Get.find<AuthService>();
    
    // Form validation
    final formKey = GlobalKey<FormState>();
    final privacyAccepted = false.obs;
    final isPasswordVisible = false.obs;
    String completePhoneNumber = '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Let's create your account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // First Name and Last Name (side by side)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: firstNameController,
                          hintText: 'First Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Username
                  _buildInputField(
                    controller: usernameController,
                    hintText: 'Username',
                    prefixIcon: Icons.account_circle_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Email
                  _buildInputField(
                    controller: emailController,
                    hintText: 'E-Mail',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone Number with Country Code
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IntlPhoneField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        completePhoneNumber = phone.completeNumber;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password
                  Obx(() => _buildInputField(
                    controller: passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    suffixIconOnTap: () => isPasswordVisible.value = !isPasswordVisible.value,
                    obscureText: !isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),
                  
                  // Privacy Policy Checkbox
                  Obx(() => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        value: privacyAccepted.value,
                        onChanged: (value) => privacyAccepted.value = value ?? false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text("I agree to "),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(" and "),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Terms of use",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 24),
                  
                  // Create Account Button
                  ElevatedButton(
                    onPressed: () async {
                      if (!privacyAccepted.value) {
                        Get.snackbar(
                          'Error',
                          'Please accept the Privacy Policy and Terms of Use',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      
                      if (formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final firstName = firstNameController.text.trim();
                        final lastName = lastNameController.text.trim();
                        final username = usernameController.text.trim();
                        final phone = completePhoneNumber.isNotEmpty 
                            ? completePhoneNumber 
                            : phoneController.text.trim();
                        
                        try {
                          final result = await authService.signUpWithEmail(email, password);
                          if (result != null) {
                            // Send email verification
                            await authService.sendEmailVerification();
                            
                            // Create user profile in Firestore
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(result.user!.uid)
                                .set({
                              'firstName': firstName,
                              'lastName': lastName,
                              'username': username,
                              'email': email,
                              'phoneNumber': phone,
                              'profilePicture': '',
                              'shippingAddress': {
                                'address': '',
                                'country': '',
                                'zipCode': ''
                              },
                              'orderHistory': [],
                              'createdAt': FieldValue.serverTimestamp(),
                              'updatedAt': FieldValue.serverTimestamp(),
                            });

                            // Create empty cart for the user
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(result.user!.uid)
                                .set({
                              'userId': result.user!.uid,
                              'items': [],
                              'estimatedTotal': 0.0,
                              'updatedAt': FieldValue.serverTimestamp(),
                            });

                            // Navigate to verification page
                            Get.offAllNamed('/email-verification');
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to create account: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Or sign up with
                  const Center(
                    child: Text('Or Sign up with'),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Social Sign Up Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Sign In
                      InkWell(
                        onTap: () async {
                          await authService.signInWithGoogle();
                          // Navigation is handled inside the authService.signInWithGoogle() method
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Image.asset(
                            'assets/logos/google-icon.png',
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Phone Sign In
                      InkWell(
                        onTap: () => Get.toNamed('/phone-auth'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(
                            Icons.phone_android,
                            size: 24,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    VoidCallback? suffixIconOnTap,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
          suffixIcon: suffixIcon != null 
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.grey[600]),
                onPressed: suffixIconOnTap,
              ) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
} 