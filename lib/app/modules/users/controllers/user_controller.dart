import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../services/firestore_service.dart';

class UserController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _subscribeToUsers();
  }

  // Subscribe to users stream
  void _subscribeToUsers() {
    _firestoreService.getUsers().listen(
      (userList) {
        users.value = userList;
      },
      onError: (error) {
        errorMessage.value = 'Error loading users: $error';
      },
    );
  }

  // Create a new user
  Future<void> createUser({
    required String email,
    required String displayName,
    String? phoneNumber,
    String? photoURL,
    required Map<String, dynamic> address,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = UserModel(
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        address: address,
        favoriteProducts: [],
        recentlyViewed: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final userId = await _firestoreService.createUser(user);
      
      if (userId == null) {
        errorMessage.value = 'Failed to create user';
      }
    } catch (e) {
      errorMessage.value = 'Error creating user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Get a single user
  Future<void> getUser(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _firestoreService.getUser(id);
      selectedUser.value = user;

      if (user == null) {
        errorMessage.value = 'User not found';
      }
    } catch (e) {
      errorMessage.value = 'Error getting user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update a user
  Future<void> updateUser(String id, {
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    Map<String, dynamic>? address,
    List<String>? favoriteProducts,
    List<String>? recentlyViewed,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = selectedUser.value;
      if (currentUser == null) {
        errorMessage.value = 'No user selected';
        return;
      }

      final updatedUser = currentUser.copyWith(
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        address: address,
        favoriteProducts: favoriteProducts,
        recentlyViewed: recentlyViewed,
        updatedAt: DateTime.now(),
      );

      final success = await _firestoreService.updateUser(id, updatedUser);
      
      if (!success) {
        errorMessage.value = 'Failed to update user';
      }
    } catch (e) {
      errorMessage.value = 'Error updating user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a user
  Future<void> deleteUser(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _firestoreService.deleteUser(id);
      
      if (!success) {
        errorMessage.value = 'Failed to delete user';
      }
    } catch (e) {
      errorMessage.value = 'Error deleting user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update user's favorite products
  Future<void> toggleFavoriteProduct(String userId, String productId) async {
    try {
      final currentUser = selectedUser.value;
      if (currentUser == null) return;

      final favorites = List<String>.from(currentUser.favoriteProducts);
      
      if (favorites.contains(productId)) {
        favorites.remove(productId);
      } else {
        favorites.add(productId);
      }

      await updateUser(userId, favoriteProducts: favorites);
    } catch (e) {
      errorMessage.value = 'Error updating favorites: $e';
    }
  }

  // Add to recently viewed products
  Future<void> addToRecentlyViewed(String userId, String productId) async {
    try {
      final currentUser = selectedUser.value;
      if (currentUser == null) return;

      final recentlyViewed = List<String>.from(currentUser.recentlyViewed);
      
      // Remove if already exists (to move it to the front)
      recentlyViewed.remove(productId);
      
      // Add to the beginning of the list
      recentlyViewed.insert(0, productId);
      
      // Keep only the last 10 items
      if (recentlyViewed.length > 10) {
        recentlyViewed.removeLast();
      }

      await updateUser(userId, recentlyViewed: recentlyViewed);
    } catch (e) {
      errorMessage.value = 'Error updating recently viewed: $e';
    }
  }
} 