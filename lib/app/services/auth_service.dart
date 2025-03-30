import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../routes/app_pages.dart';
import 'auth_service_web.dart' if (dart.library.io) 'auth_service_mobile.dart';
import 'firestore_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Configure Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '872644437819-sp9k9itcmojoi5tnbc2e5v9nfqgb8vp4.apps.googleusercontent.com' : null,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  Rx<User?> currentUser = Rx<User?>(null);
  
  // For phone verification
  final RxString verificationId = RxString('');
  final RxBool isPhoneVerificationInProgress = RxBool(false);
  
  Future<AuthService> init() async {
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
    return this;
  }
  
  // Helper method to show dialogs
  void _showDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(message),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show API configuration dialog
  void _showApiConfigDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'API Configuration Required',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('The People API needs to be enabled in your Google Cloud Console.'),
              const SizedBox(height: 12),
              const Text('Please follow these steps:'),
              const SizedBox(height: 8),
              const Text('1. Go to Google Cloud Console', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('2. Search for "People API"'),
              const Text('3. Enable the API'),
              const Text('4. Wait a few minutes'),
              const Text('5. Try signing in again'),
              const SizedBox(height: 16),
              const Text('This is a one-time setup requirement.'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show reCAPTCHA dialog
  void _showRecaptchaDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'reCAPTCHA Issue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('There was an issue with the reCAPTCHA verification.'),
              const SizedBox(height: 12),
              const Text('This is often due to:'),
              const SizedBox(height: 8),
              const Text('• Poor internet connection'),
              const Text('• Outdated Google Play Services'),
              const Text('• Firebase configuration issues'),
              const SizedBox(height: 12),
              const Text('You can try:'),
              const Text('• Restarting the app'),
              const Text('• Updating Google Play Services'),
              const Text('• Using a different sign-in method'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show verification issue dialog
  void _showVerificationIssueDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification Issue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('There was an issue with the reCAPTCHA verification.'),
              const SizedBox(height: 12),
              const Text('Please try the following:'),
              const SizedBox(height: 8),
              const Text('1. Make sure you have a stable internet connection'),
              const Text('2. Try a different browser (if on web)'),
              const Text('3. Update Google Play Services (if on Android)'),
              const SizedBox(height: 12),
              const Text('If the issue persists, try signing in with email/password or Google instead.'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show billing required dialog
  void _showBillingRequiredDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Billing Required',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Firebase Phone Authentication requires a billing account to be set up.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Please follow these steps:'),
              const SizedBox(height: 8),
              const Text('1. Go to the Firebase Console'),
              const Text('2. Select your project'),
              const Text('3. Go to "Billing" section'),
              const Text('4. Set up a billing account'),
              const Text('5. The free tier includes enough SMS messages for testing'),
              const SizedBox(height: 16),
              const Text(
                'For now, please use Google Sign-In or Email/Password authentication instead.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back(); // Go back to the login screen too
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show Firestore permissions dialog
  void _showFirestorePermissionsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Firestore Permissions Issue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Firebase Firestore security rules are preventing data access.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Please update your Firestore security rules:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'rules_version = \'2\';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    match /users/{userId} {\n      allow read, write: if request.auth != null && request.auth.uid == userId;\n    }\n    match /{document=**} {\n      allow read, write: if request.auth != null;\n    }\n  }\n}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Go to Firebase Console > Firestore Database > Rules tab and update your rules.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Email & Password Sign In
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many unsuccessful login attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in.';
      }
      debugPrint('Email Login Error: ${e.code} - $message');
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      debugPrint('General Login Error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  // Email & Password Sign Up
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      // Check if email already exists
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        Get.snackbar(
          'Error',
          'Email already in use. Please try another email or sign in.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use. Please try another email.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign up.';
      }
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  // Send Email Verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          'Verification Email Sent',
          'Please check your email to verify your account',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Check Email Verification Status
  Future<bool> checkEmailVerified() async {
    User? user = _auth.currentUser;
    if (user == null) return false;
    
    await user.reload();
    user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }
  
  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential? userCredential;

      if (kIsWeb) {
        // Web flow
        try {
          final GoogleAuthProvider googleProvider = GoogleAuthProvider();
          userCredential = await _auth.signInWithPopup(googleProvider);
        } catch (e) {
          debugPrint('Web Google Sign In Error: $e');
          throw 'Could not sign in with Google. Please try again.';
        }
      } else {
        // Mobile flow - Fixed implementation
        try {
          // Sign out from any previous Google Sign-In
          await _googleSignIn.signOut();
          
          // Begin sign in process
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          // User canceled the sign-in flow
          if (googleUser == null) {
            return null;
          }

          // Get authentication details
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          
          // Create credential
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in with Firebase
          userCredential = await _auth.signInWithCredential(credential);
          
          // Show success message
          Get.snackbar(
            'Success',
            'Signed in with Google successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (error) {
          debugPrint('Google Sign In Error: $error');
          
          // Show error message to user
          Get.snackbar(
            'Google Sign In Error',
            'Failed to sign in with Google: ${error.toString()}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          
          return null;
        }
      }

      // Save user data to Firestore if sign in was successful
      if (userCredential != null && userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user);
        
        // Navigate to home page on success
        Get.offAllNamed(Routes.HOME);
      }

      return userCredential;
    } catch (error) {
      // Show a more user-friendly error message
      Get.snackbar(
        'Authentication Error',
        'Something went wrong with Google Sign-In. Please try again or use email login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      debugPrint('Google Sign In General Error: $error');
      return null;
    }
  }
  
  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;
    
    try {
      await _firestoreService.createOrUpdateUser({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'lastLogin': DateTime.now(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      debugPrint('Error saving user data: $error');
      // We don't throw here to prevent blocking sign-in even if Firestore update fails
    }
  }
  
  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Reset Password Error: $e');
      throw 'Could not send password reset email. Please check your email address.';
    }
  }
  
  // Phone Authentication Step 1: Send OTP
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    isPhoneVerificationInProgress.value = true;
    
    try {
      debugPrint('Starting phone verification for: $phoneNumber');
      
      if (kIsWeb) {
        debugPrint('Running on web, checking for reCAPTCHA container');
        ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
          phoneNumber,
          RecaptchaVerifier(
            container: 'recaptcha-container',
            size: RecaptchaVerifierSize.compact,
            theme: RecaptchaVerifierTheme.light,
            auth: FirebaseAuthPlatform.instance,
          ),
        );
        
        verificationId.value = confirmationResult.verificationId;
        isPhoneVerificationInProgress.value = false;
        Get.toNamed('/verify-otp');
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            debugPrint('Auto-verification triggered');
            try {
              final userCredential = await _auth.signInWithCredential(credential);
              isPhoneVerificationInProgress.value = false;
              
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .set({
                'phoneNumber': userCredential.user!.phoneNumber ?? '',
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
              
              Get.offAllNamed('/home');
            } catch (e) {
              debugPrint('Auto-verification error: $e');
              isPhoneVerificationInProgress.value = false;
              Get.snackbar(
                'Error',
                'Auto-verification failed: ${e.toString()}',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            isPhoneVerificationInProgress.value = false;
            String message;
            debugPrint('Phone verification failed: ${e.code} - ${e.message}');
            
            switch (e.code) {
              case 'invalid-phone-number':
                message = 'The phone number is not valid.';
                break;
              case 'too-many-requests':
                message = 'Too many verification attempts. Try again later.';
                break;
              case 'app-not-authorized':
                message = 'The app is not authorized to use Firebase Authentication.';
                break;
              case 'missing-client-identifier':
                message = 'The reCAPTCHA token is missing. Try again.';
                break;
              case 'captcha-check-failed':
                message = 'The reCAPTCHA verification failed. Try again.';
                break;
              case 'quota-exceeded':
                message = 'The SMS quota for the project has been exceeded.';
                break;
              case 'billing-not-enabled':
                message = 'Firebase billing is not enabled for this project. Phone authentication requires a billing account.';
                _showBillingRequiredDialog();
                return;
              default:
                message = e.message ?? 'An error occurred during phone verification.';
            }
            
            if (e.code == 'missing-client-identifier' || e.code == 'captcha-check-failed') {
              _showVerificationIssueDialog();
            } else {
              Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
            }
          },
          codeSent: (String vId, int? resendToken) {
            debugPrint('SMS code sent! Verification ID: $vId');
            verificationId.value = vId;
            isPhoneVerificationInProgress.value = false;
            Get.toNamed('/verify-otp');
          },
          codeAutoRetrievalTimeout: (String vId) {
            debugPrint('Auto retrieval timeout');
            verificationId.value = vId;
            isPhoneVerificationInProgress.value = false;
          },
          timeout: const Duration(seconds: 120),
        );
      }
    } catch (e) {
      debugPrint('General phone verification error: $e');
      isPhoneVerificationInProgress.value = false;
      
      if (e.toString().contains('reCAPTCHA')) {
        _showRecaptchaDialog();
      } else {
        Get.snackbar(
          'Error',
          'Failed to verify phone number: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  
  // Phone Authentication Step 2: Verify OTP and Sign In
  Future<UserCredential?> verifyOTPAndSignIn(String otp) async {
    try {
      if (verificationId.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Verification ID is missing. Please restart the verification process.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
      
      // Create credential with the OTP and verification ID
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      
      // Sign in with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Create or update user profile
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'phoneNumber': userCredential.user!.phoneNumber ?? '',
          'name': userCredential.user!.displayName ?? '',
          'email': userCredential.user!.email ?? '',
          'profilePicture': userCredential.user!.photoURL ?? '',
          'shippingAddress': {
            'address': '',
            'country': '',
            'zipCode': ''
          },
          'orderHistory': [],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-verification-code':
          message = 'The verification code is invalid. Please check and try again.';
          break;
        default:
          message = e.message ?? 'An error occurred during OTP verification.';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Get Current User
  User? get currentUserData => _auth.currentUser;
  
  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
} 