import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "welcome_to_shoevogue".tr,
          body: "discover_latest_trends".tr,
          image: Image.asset('assets/images/on_boarding_images/sammy-line-searching.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            imagePadding: EdgeInsets.only(top: 40),
            // Add background color based on theme
            boxDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        PageViewModel(
          title: "shop_with_ease".tr,
          body: "browse_collection".tr,
          image: Image.asset('assets/images/on_boarding_images/sammy-line-shopping.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            imagePadding: EdgeInsets.only(top: 40),
            boxDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        PageViewModel(
          title: "fast_delivery".tr,
          body: "get_shoes_delivered".tr,
          image: Image.asset('assets/images/on_boarding_images/sammy-line-delivery.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            imagePadding: EdgeInsets.only(top: 40),
            boxDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        PageViewModel(
          title: "always_connected".tr,
          body: "stay_updated".tr,
          image: Image.asset('assets/images/on_boarding_images/sammy-line-no-connection.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            imagePadding: EdgeInsets.only(top: 40),
            boxDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ],
      showSkipButton: true,
      skip: Text(
        'skip'.tr,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      next: Text(
        'next'.tr,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      done: Text(
        'get_started'.tr, 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        )
      ),
      onDone: () => _onIntroEnd(),
      onSkip: () => _onIntroEnd(),
      skipOrBackFlex: 0,
      nextFlex: 0,
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: isDark ? Colors.grey.shade700 : Color(0xFFBDBDBD),
        activeColor: Theme.of(context).colorScheme.primary,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  void _onIntroEnd() async {
    try {
      // Set flag that onboarding is completed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      
      // Navigate to login screen
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      debugPrint('Error during onboarding completion: $e');
      // Fallback navigation if there's an error
      Get.offAllNamed(Routes.LOGIN);
    }
  }
} 