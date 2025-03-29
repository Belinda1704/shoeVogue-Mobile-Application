import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shoe_vogue/app/data/models/banner_model.dart';
import 'package:shoe_vogue/app/modules/home/views/home_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Carousel Banner Test Widget
  Widget createCarouselTestWidget() {
    final banners = [
      BannerModel(
        id: 'banner1',
        imageUrl: 'assets/images/banners/banner_1.jpg',
        title: 'Summer Collection with a Very Long Title That Might Overflow',
        subtitle: 'Check out our latest summer styles with a very detailed description that might cause overflow issues on small screens',
        actionText: 'Shop Now with Special Discount',
        actionUrl: '/products?category=summer',
        isActive: true,
        priority: 1,
      ),
    ];

    return MaterialApp(
      home: Scaffold(
        body: CarouselSlider(
          options: CarouselOptions(
            height: 180,
            aspectRatio: 16/9,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3))],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
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
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (banner.subtitle != null)
                                Text(
                                  banner.subtitle!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
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
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // Product Card Test Widget
  Widget createProductCardTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 180,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: const Icon(Icons.image, size: 40),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Very Long Product Name That Might Cause Overflow Issues on Small Screens',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '\$199.99',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Drawer Test Widget
  Widget createDrawerTestWidget() {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ShoeVogue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Find your perfect pair of shoes with our extensive collection that fits your style',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories with a very long text that might overflow'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help Center with Extended Description'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Open Drawer'),
          ),
        ),
      ),
    );
  }

  group('Responsiveness Tests', () {
    for (final size in [
      const Size(320, 480),   // Small phone
      const Size(375, 667),   // iPhone 8
      const Size(414, 896),   // iPhone 11
      const Size(768, 1024),  // Tablet
    ]) {
      testWidgets('Banner carousel should not overflow on ${size.width}x${size.height} screen',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createCarouselTestWidget());
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('Product card should not overflow on ${size.width}x${size.height} screen',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createProductCardTestWidget());
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('Drawer should not overflow on ${size.width}x${size.height} screen',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createDrawerTestWidget());
        await tester.pumpAndSettle();

        // Open the drawer
        final ScaffoldState state = tester.state(find.byType(Scaffold));
        state.openDrawer();
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Orientation Tests', () {
    for (final size in [
      const Size(480, 320),   // Small phone landscape
      const Size(667, 375),   // iPhone 8 landscape
      const Size(896, 414),   // iPhone 11 landscape
    ]) {
      testWidgets('Banner carousel should handle landscape orientation ${size.width}x${size.height}',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createCarouselTestWidget());
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('Product card should handle landscape orientation ${size.width}x${size.height}',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createProductCardTestWidget());
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('Drawer should handle landscape orientation ${size.width}x${size.height}',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = size;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(createDrawerTestWidget());
        await tester.pumpAndSettle();

        // Open the drawer
        final ScaffoldState state = tester.state(find.byType(Scaffold));
        state.openDrawer();
        await tester.pumpAndSettle();

        // This will fail if there are any overflow errors
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Text Overflow Tests', () {
    testWidgets('Long text should be ellipsized in product card', (WidgetTester tester) async {
      await tester.pumpWidget(createProductCardTestWidget());
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.text('Very Long Product Name That Might Cause Overflow Issues on Small Screens')
      );
      
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });

    testWidgets('Long text should be ellipsized in banner subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(createCarouselTestWidget());
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.text('Check out our latest summer styles with a very detailed description that might cause overflow issues on small screens')
      );
      
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });

    testWidgets('Drawer title should handle long text', (WidgetTester tester) async {
      await tester.pumpWidget(createDrawerTestWidget());
      await tester.pumpAndSettle();

      // Open the drawer
      final ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.text('Categories with a very long text that might overflow')
      );
      
      // No explicit expect here, but we're checking that the drawer renders without errors
      expect(tester.takeException(), isNull);
    });
  });
} 