@echo off
echo Running Unit Tests...
flutter test test/unit/models/banner_model_test.dart
flutter test test/unit/controllers/home_controller_test.dart

echo Running Widget Tests...
flutter test test/widget/components/banner_carousel_test.dart
flutter test test/widget/views/home_view_test.dart
flutter test test/widget/responsive/responsive_widgets_test.dart

echo Running Integration Tests...
flutter test integration_test/app_test.dart

echo All tests completed!

echo Running widget tests for ShoeVogue app...
flutter test test/simple_widget_tests.dart
echo.
echo Tests completed. 20 widget tests should have passed!
pause 