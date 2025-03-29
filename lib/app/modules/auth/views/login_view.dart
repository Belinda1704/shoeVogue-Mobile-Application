import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/auth_service.dart';

class LoginView extends GetView {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginViewController());
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover timeless choices and unmatched convenience.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              // Email field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: 'E-Mail',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => controller.togglePasswordVisibility(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  obscureText: !controller.isPasswordVisible.value,
                ),
              )),
              const SizedBox(height: 16),
              // Remember me and Forgot password
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (value) => controller.toggleRememberMe(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                  const Text('Remember Me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Sign in button
              ElevatedButton(
                onPressed: () => controller.signIn(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Or sign in with
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or sign in with',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 24),
              // Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Sign In
                  InkWell(
                    onTap: () => controller.signInWithGoogle(),
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
              // Create Account button
              OutlinedButton(
                onPressed: () => Get.toNamed('/signup'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginViewController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final authService = Get.find<AuthService>();
  final storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    // Load saved email if "Remember Me" was checked
    if (storage.hasData('rememberMe') && storage.read('rememberMe') == true) {
      rememberMe.value = true;
      if (storage.hasData('email')) {
        emailController.text = storage.read('email');
      }
    }
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    storage.write('rememberMe', rememberMe.value);
    if (!rememberMe.value) {
      storage.remove('email');
    }
  }
  
  void signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Save email if "Remember Me" is checked
    if (rememberMe.value) {
      storage.write('email', email);
    }
    
    final result = await authService.signInWithEmail(email, password);
    if (result != null) {
      Get.offAllNamed('/home');
    }
  }
  
  void signInWithGoogle() async {
    await authService.signInWithGoogle();
    // Navigation is handled inside the authService.signInWithGoogle() method
  }
} 