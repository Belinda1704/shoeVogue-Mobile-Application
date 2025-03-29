import 'package:flutter_test/flutter_test.dart';
import 'package:shoe_vogue/app/data/models/banner_model.dart';

void main() {
  group('BannerModel', () {
    test('should create a valid BannerModel from constructor', () {
      final banner = BannerModel(
        id: 'test_id',
        imageUrl: 'https://example.com/image.jpg',
        title: 'Test Banner',
        subtitle: 'Test Subtitle',
        actionText: 'Shop Now',
        actionUrl: '/products',
        isActive: true,
        priority: 1,
      );

      expect(banner.id, 'test_id');
      expect(banner.imageUrl, 'https://example.com/image.jpg');
      expect(banner.title, 'Test Banner');
      expect(banner.subtitle, 'Test Subtitle');
      expect(banner.actionText, 'Shop Now');
      expect(banner.actionUrl, '/products');
      expect(banner.isActive, true);
      expect(banner.priority, 1);
    });

    test('should create a valid BannerModel from Map', () {
      final map = {
        'imageUrl': 'https://example.com/image.jpg',
        'title': 'Test Banner',
        'subtitle': 'Test Subtitle',
        'actionText': 'Shop Now',
        'actionUrl': '/products',
        'isActive': true,
        'priority': 1,
      };

      final banner = BannerModel.fromMap(map, 'test_id');

      expect(banner.id, 'test_id');
      expect(banner.imageUrl, 'https://example.com/image.jpg');
      expect(banner.title, 'Test Banner');
      expect(banner.subtitle, 'Test Subtitle');
      expect(banner.actionText, 'Shop Now');
      expect(banner.actionUrl, '/products');
      expect(banner.isActive, true);
      expect(banner.priority, 1);
    });

    test('should convert BannerModel to Map', () {
      final banner = BannerModel(
        id: 'test_id',
        imageUrl: 'https://example.com/image.jpg',
        title: 'Test Banner',
        subtitle: 'Test Subtitle',
        actionText: 'Shop Now',
        actionUrl: '/products',
        isActive: true,
        priority: 1,
      );

      final map = banner.toMap();

      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['title'], 'Test Banner');
      expect(map['subtitle'], 'Test Subtitle');
      expect(map['actionText'], 'Shop Now');
      expect(map['actionUrl'], '/products');
      expect(map['isActive'], true);
      expect(map['priority'], 1);
    });

    test('should handle missing optional fields from Map', () {
      final map = {
        'imageUrl': 'https://example.com/image.jpg',
        'title': 'Test Banner',
        'isActive': true,
        'priority': 1,
      };

      final banner = BannerModel.fromMap(map, 'test_id');

      expect(banner.id, 'test_id');
      expect(banner.imageUrl, 'https://example.com/image.jpg');
      expect(banner.title, 'Test Banner');
      expect(banner.subtitle, null);
      expect(banner.actionText, null);
      expect(banner.actionUrl, null);
      expect(banner.isActive, true);
      expect(banner.priority, 1);
    });
    
    test('isCurrentlyActive should return correct status based on dates', () {
      final now = DateTime.now();
      
      // Banner with no date restrictions
      final alwaysActiveBanner = BannerModel(
        id: 'banner1',
        imageUrl: 'image1.jpg',
        title: 'Always Active',
        isActive: true,
        priority: 1,
      );
      expect(alwaysActiveBanner.isCurrentlyActive(), true);
      
      // Inactive banner
      final inactiveBanner = BannerModel(
        id: 'banner2',
        imageUrl: 'image2.jpg',
        title: 'Inactive',
        isActive: false,
        priority: 2,
      );
      expect(inactiveBanner.isCurrentlyActive(), false);
      
      // Future banner
      final futureBanner = BannerModel(
        id: 'banner3',
        imageUrl: 'image3.jpg',
        title: 'Future',
        isActive: true,
        priority: 3,
        startDate: now.add(const Duration(days: 1)),
      );
      expect(futureBanner.isCurrentlyActive(), false);
      
      // Expired banner
      final expiredBanner = BannerModel(
        id: 'banner4',
        imageUrl: 'image4.jpg',
        title: 'Expired',
        isActive: true,
        priority: 4,
        endDate: now.subtract(const Duration(days: 1)),
      );
      expect(expiredBanner.isCurrentlyActive(), false);
      
      // Valid date range banner
      final validRangeBanner = BannerModel(
        id: 'banner5',
        imageUrl: 'image5.jpg',
        title: 'Valid Range',
        isActive: true,
        priority: 5,
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 1)),
      );
      expect(validRangeBanner.isCurrentlyActive(), true);
    });
  });
} 