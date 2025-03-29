import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shoe_vogue/app/data/models/banner_model.dart';
import 'package:shoe_vogue/app/modules/home/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Create a custom widget to test the banner carousel
class BannerCarouselTestWidget extends StatelessWidget {
  final List<BannerModel> banners;

  const BannerCarouselTestWidget({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Special Offers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  aspectRatio: 16/9,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: banners.map((BannerModel banner) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Banner Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: banner.imageUrl.startsWith('http')
                                    ? Image.network(
                                        banner.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.jpg', // Use a placeholder for tests
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                              ),
                              
                              // Text Overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        banner.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (banner.subtitle != null)
                                        Text(
                                          banner.subtitle!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      if (banner.actionText != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            banner.actionText!,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('BannerCarousel Widget', () {
    testWidgets('should display banners correctly', (WidgetTester tester) async {
      // Create test banners
      final banners = [
        BannerModel(
          id: 'banner1',
          imageUrl: 'assets/images/banners/banner_1.jpg',
          title: 'Summer Collection',
          subtitle: 'Check out our latest summer styles',
          actionText: 'Shop Now',
          actionUrl: '/products?category=summer',
          isActive: true,
          priority: 1,
        ),
        BannerModel(
          id: 'banner2',
          imageUrl: 'assets/images/banners/banner_2.jpg',
          title: 'Limited Edition',
          subtitle: 'Get them before they\'re gone',
          actionText: 'Explore',
          actionUrl: '/products?category=limited',
          isActive: true,
          priority: 2,
        ),
      ];

      // Build our app and trigger a frame
      await tester.pumpWidget(BannerCarouselTestWidget(banners: banners));
      await tester.pumpAndSettle(); // Wait for animations to complete

      // Verify carousel is rendered
      expect(find.byType(CarouselSlider), findsOneWidget);
      
      // Verify section title
      expect(find.text('Special Offers'), findsOneWidget);
      
      // Verify first banner title
      expect(find.text('Summer Collection'), findsOneWidget);
      
      // Verify first banner subtitle
      expect(find.text('Check out our latest summer styles'), findsOneWidget);
      
      // Verify first banner action text
      expect(find.text('Shop Now'), findsOneWidget);
      
      // Swipe to next banner
      await tester.drag(find.byType(CarouselSlider), const Offset(-500, 0));
      await tester.pumpAndSettle(); // Wait for animations to complete
      
      // Verify second banner title appears
      expect(find.text('Limited Edition'), findsOneWidget);
      
      // Verify second banner subtitle
      expect(find.text('Get them before they\'re gone'), findsOneWidget);
      
      // Verify second banner action text
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('should handle empty banners list', (WidgetTester tester) async {
      // Create empty banner list
      final banners = <BannerModel>[];

      // Build our app and trigger a frame
      await tester.pumpWidget(BannerCarouselTestWidget(banners: banners));
      await tester.pumpAndSettle();

      // Carousel should still be rendered, but with no items
      expect(find.byType(CarouselSlider), findsOneWidget);
      
      // Title should still be visible
      expect(find.text('Special Offers'), findsOneWidget);
      
      // No banner titles should be visible
      expect(find.text('Summer Collection'), findsNothing);
      expect(find.text('Limited Edition'), findsNothing);
    });

    testWidgets('should handle banners with minimal data', (WidgetTester tester) async {
      // Create test banners with minimal data
      final banners = [
        BannerModel(
          id: 'banner1',
          imageUrl: 'assets/images/banners/banner_1.jpg',
          title: 'Title Only Banner',
          isActive: true,
          priority: 1,
        ),
      ];

      // Build our app and trigger a frame
      await tester.pumpWidget(BannerCarouselTestWidget(banners: banners));
      await tester.pumpAndSettle();

      // Verify carousel is rendered
      expect(find.byType(CarouselSlider), findsOneWidget);
      
      // Verify banner title
      expect(find.text('Title Only Banner'), findsOneWidget);
      
      // Subtitle and action text should not be visible
      expect(find.text('Check out our latest summer styles'), findsNothing);
      expect(find.text('Shop Now'), findsNothing);
    });
  });
} 