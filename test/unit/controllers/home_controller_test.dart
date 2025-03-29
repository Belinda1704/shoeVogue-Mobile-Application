import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shoe_vogue/app/modules/home/controllers/home_controller.dart';
import 'package:shoe_vogue/app/services/firestore_service.dart';
import 'package:shoe_vogue/app/data/models/banner_model.dart';
import 'dart:async';

// Manual mock class for FirestoreService
class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<BannerModel>> getBanners() {
    return Stream.value([
      BannerModel(
        id: 'test_banner',
        imageUrl: 'test_image_url',
        title: 'Test Banner',
        isActive: true,
        priority: 1
      )
    ]);
  }
}

void main() {
  late HomeController controller;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    
    // Register mocked service with GetX
    Get.put<FirestoreService>(mockFirestoreService);
    
    // Initialize controller
    controller = HomeController();
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController', () {
    test('should initialize with default values', () {
      // Verify initial values
      expect(controller.currentIndex, 0);
      expect(controller.products, isEmpty);
      expect(controller.selectedCategory, 'All');
      expect(controller.filteredProducts, isEmpty);
      expect(controller.banners, isEmpty);
      expect(controller.isLoadingBanners, true);
    });

    test('should change current index when changePage is called', () {
      // Initial index should be 0
      expect(controller.currentIndex, 0);
      
      // Change page
      controller.changePage(2);
      
      // Index should be updated
      expect(controller.currentIndex, 2);
    });

    test('should change category and filter products', () {
      // Setup test products
      final testProducts = [
        {'id': '1', 'name': 'Product 1', 'category': 'Sneakers', 'price': 99.99},
        {'id': '2', 'name': 'Product 2', 'category': 'Formal', 'price': 149.99},
        {'id': '3', 'name': 'Product 3', 'category': 'Sneakers', 'price': 79.99},
      ];
      controller.products.assignAll(testProducts);
      
      // Initial category should be All, showing all products
      expect(controller.selectedCategory, 'All');
      controller.filterProducts(); // Manually call to ensure products are filtered
      expect(controller.filteredProducts.length, 3);
      
      // Change category to Sneakers
      controller.changeCategory('Sneakers');
      
      // Category should be updated
      expect(controller.selectedCategory, 'Sneakers');
      
      // Only Sneakers products should be shown
      expect(controller.filteredProducts.length, 2);
      expect(controller.filteredProducts[0]['id'], '1');
      expect(controller.filteredProducts[1]['id'], '3');
    });

    test('should load banners from FirestoreService', () async {
      // Mock data
      final bannerList = [
        BannerModel(
          id: 'banner1',
          imageUrl: 'test_url_1',
          title: 'Banner 1',
          isActive: true,
          priority: 1,
        ),
        BannerModel(
          id: 'banner2',
          imageUrl: 'test_url_2',
          title: 'Banner 2',
          isActive: true,
          priority: 2,
        ),
      ];
      
      // Setup mock response
      when(mockFirestoreService.getBanners()).thenAnswer(
        (_) => Stream.value(bannerList),
      );
      
      // Call the method
      controller.loadBanners();
      
      // Using Future.delayed for async operation
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify the banners are loaded
      expect(controller.banners.length, 2);
      expect(controller.banners[0].id, 'banner1');
      expect(controller.banners[1].id, 'banner2');
      expect(controller.isLoadingBanners, false);
    });

    test('should handle errors when loading banners', () async {
      // Setup mock to throw error
      when(mockFirestoreService.getBanners()).thenAnswer(
        (_) => Stream.error('Test error'),
      );
      
      // Call the method
      controller.loadBanners();
      
      // Using Future.delayed for async operation
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify local banners are loaded on error
      expect(controller.banners.isNotEmpty, true);
      expect(controller.isLoadingBanners, false);
    });
  });
} 