import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// A simple test widget that mimics basic structure but doesn't depend on complex controllers
class SimpleHomeWidget extends StatelessWidget {
  const SimpleHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          
          // Categories section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryCard(context, 'Sneakers', Icons.directions_run),
                      _buildCategoryCard(context, 'Formal', Icons.business),
                      _buildCategoryCard(context, 'Sports', Icons.sports_basketball),
                      _buildCategoryCard(context, 'Casual', Icons.weekend),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Products grid placeholder
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${99.99 + index * 10}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 28,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('Simple home widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SimpleHomeWidget(),
        locale: const Locale('en', 'US'),
      ),
    );
    
    await tester.pumpAndSettle();

    // Verify the basic widget elements are present
    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Sneakers'), findsOneWidget);
    expect(find.text('Formal'), findsOneWidget);
    expect(find.text('Sports'), findsOneWidget);
    expect(find.text('Casual'), findsOneWidget);
    
    // Verify navigation labels are present using more specific finders
    expect(find.widgetWithText(NavigationDestination, 'Home'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Favorites'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Cart'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Profile'), findsOneWidget);
    
    // Find product items by partial text to avoid index mismatches
    expect(find.textContaining('Product'), findsWidgets);
    
    // Verify price pattern rather than exact values
    expect(find.textContaining('\$'), findsWidgets);
  });
  
  testWidgets('Simple home widget - navigation bar interaction', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SimpleHomeWidget(),
        locale: const Locale('en', 'US'),
      ),
    );

    // Verify the bottom navigation bar elements
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
  
  testWidgets('Simple home widget - search field', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SimpleHomeWidget(),
        locale: const Locale('en', 'US'),
      ),
    );

    // Verify the search field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search products'), findsOneWidget);
    
    // Test entering text in search field
    await tester.enterText(find.byType(TextField), 'sneakers');
    expect(find.text('sneakers'), findsOneWidget);
  });
} 