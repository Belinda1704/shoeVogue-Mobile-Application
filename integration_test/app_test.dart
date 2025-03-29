import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shoe_vogue/main.dart' as app;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete user flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the app starts with onboarding or home page
      expect(find.byType(Scaffold), findsOneWidget);

      // If we're on the onboarding screen, navigate through it
      if (find.text('Discover a variety of shoes').evaluate().isNotEmpty ||
          find.text('Welcome to ShoeVogue').evaluate().isNotEmpty) {
        // We're on onboarding, let's proceed through it
        for (int i = 0; i < 3; i++) {
          await tester.drag(find.byType(PageView), const Offset(-300, 0));
          await tester.pumpAndSettle();
        }

        // Find and tap the "Get Started" button
        final getStartedFinder = find.text('Get Started');
        if (getStartedFinder.evaluate().isNotEmpty) {
          await tester.tap(getStartedFinder);
          await tester.pumpAndSettle();
        } else {
          // Try alternative "Skip" button if "Get Started" is not found
          await tester.tap(find.text('Skip'));
          await tester.pumpAndSettle();
        }
      }

      // Now we should be on either login or home page
      // If we're on login, let's skip for now since we're focusing on UI testing
      if (find.text('Login').evaluate().isNotEmpty || find.text('Sign In').evaluate().isNotEmpty) {
        // Skip Login for this test (UI test only)
        // In real integration test, you would input credentials here
        
        // Find and tap the "Skip" or "Continue as Guest" button if available
        final skipFinder = find.text('Skip');
        final guestFinder = find.text('Continue as Guest');
        
        if (skipFinder.evaluate().isNotEmpty) {
          await tester.tap(skipFinder);
          await tester.pumpAndSettle();
        } else if (guestFinder.evaluate().isNotEmpty) {
          await tester.tap(guestFinder);
          await tester.pumpAndSettle();
        }
      }

      // Now we should be on the home page
      // Verify bottom navigation is visible
      expect(find.byType(NavigationBar), findsOneWidget);
      
      // Test opening the drawer
      await tester.tap(find.byIcon(Icons.menu).first);
      await tester.pumpAndSettle();
      
      // Verify drawer appears
      expect(find.byType(Drawer), findsOneWidget);
      
      // Test drawer navigation - settings
      await tester.tap(find.text('settings'.tr));
      await tester.pumpAndSettle();
      
      // Verify we are on settings page
      expect(find.text('settings'.tr), findsOneWidget);
      
      // Look for either 'appearance' or 'Appearance' text
      final appearanceFinder1 = find.text('appearance'.tr);
      final appearanceFinder2 = find.text('Appearance');
      expect(
        appearanceFinder1.evaluate().isNotEmpty || appearanceFinder2.evaluate().isNotEmpty,
        isTrue,
        reason: 'Either appearance or Appearance text should be visible'
      );
      
      // Navigate back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Test navigation bar - favorites tab
      await tester.tap(find.byIcon(Icons.favorite_outline));
      await tester.pumpAndSettle();
      
      // Verify we are on favorites page
      expect(find.text('favorites'.tr), findsOneWidget);
      
      // Test navigation bar - cart tab
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      
      // Verify we are on cart page
      expect(find.text('cart'.tr), findsOneWidget);
      
      // Test navigation bar - profile tab
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      
      // Verify we are on profile page
      expect(find.text('profile'.tr), findsOneWidget);
      
      // Go back to home tab
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      
      // Verify banner carousel exists (look for either CarouselSlider or PageView)
      final carouselFinder = find.byType(CarouselSlider);
      final pageViewFinder = find.byType(PageView);
      expect(
        carouselFinder.evaluate().isNotEmpty || pageViewFinder.evaluate().isNotEmpty,
        isTrue,
        reason: 'Either CarouselSlider or PageView should be visible'
      );
      
      // Test category selection
      final sneakersFinder1 = find.text('sneakers'.tr);
      final sneakersFinder2 = find.text('Sneakers');
      
      if (sneakersFinder1.evaluate().isNotEmpty) {
        await tester.tap(sneakersFinder1);
        await tester.pumpAndSettle();
      } else if (sneakersFinder2.evaluate().isNotEmpty) {
        await tester.tap(sneakersFinder2);
        await tester.pumpAndSettle();
      }

      // Verify search field functionality
      final searchFieldFinder = find.byType(TextField);
      if (searchFieldFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFieldFinder.first);
        await tester.pumpAndSettle();
        await tester.enterText(searchFieldFinder.first, 'sneakers');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
      }
      
      // Test dark mode toggle
      await tester.tap(find.byIcon(Icons.menu).first);
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('settings'.tr));
      await tester.pumpAndSettle();
      
      final darkModeFinder1 = find.text('dark_mode'.tr);
      final darkModeFinder2 = find.text('Dark Mode');
      
      if (darkModeFinder1.evaluate().isNotEmpty || darkModeFinder2.evaluate().isNotEmpty) {
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();
        
        // Verify the theme has changed
        final ThemeData currentTheme = Theme.of(tester.element(find.byType(Scaffold)));
        expect(currentTheme.brightness, Brightness.dark);
        
        // Toggle back to light mode
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();
        
        // Verify theme is back to light
        final ThemeData updatedTheme = Theme.of(tester.element(find.byType(Scaffold)));
        expect(updatedTheme.brightness, Brightness.light);
      }
      
      // Navigate back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    testWidgets('Should handle orientation changes without overflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Skip onboarding/login if needed (simplified from previous test)
      // Here we're just assuming we get to the home page successfully

      // Test in portrait mode first
      await tester.binding.setSurfaceSize(const Size(420, 800));
      await tester.pumpAndSettle();
      
      // Verify key components are visible in portrait
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      
      // Change to landscape mode
      await tester.binding.setSurfaceSize(const Size(800, 420));
      await tester.pumpAndSettle();
      
      // Verify key components are still visible in landscape
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      
      // Check for any overflow errors
      expect(tester.takeException(), isNull);
      
      // Return to portrait for next tests
      await tester.binding.setSurfaceSize(const Size(420, 800));
      await tester.pumpAndSettle();
    });
  });
} 