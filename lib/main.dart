import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_service.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'app/services/payment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Clear SharedPreferences for testing
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize Services
  Get.put(FirebaseService());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => PaymentService().init());
  
  runApp(const App());
}

