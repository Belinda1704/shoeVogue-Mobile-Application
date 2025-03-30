// Mock implementations for FirestoreService and AuthService
import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:shoe_vogue/app/services/auth_service.dart';
import 'package:shoe_vogue/app/services/firestore_service.dart';
import 'package:shoe_vogue/app/data/models/banner_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<BannerModel>> getBanners() {
    return Stream.value([]);
  }
  
  @override
  Future<bool> addToFavorites(String userId, String productId) async {
    return true;
  }
  
  @override
  Future<bool> removeFromFavorites(String userId, String productId) async {
    return true;
  }
}

class MockAuthService extends Mock implements AuthService {
  @override
  Rx<User?> get currentUser => Rx<User?>(null);
} 