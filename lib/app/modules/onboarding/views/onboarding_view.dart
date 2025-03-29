import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to ShoeVogue",
          body: "Discover the latest trends in footwear fashion",
          image: Image.asset('assets/images/on_boarding_images/sammy-line-searching.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Shop with Ease",
          body: "Browse through our curated collection of premium shoes",
          image: Image.asset('assets/images/on_boarding_images/sammy-line-shopping.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Fast Delivery",
          body: "Get your favorite shoes delivered right to your doorstep",
          image: Image.asset('assets/images/on_boarding_images/sammy-line-delivery.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Always Connected",
          body: "Stay updated with the latest arrivals and exclusive offers",
          image: Image.asset('assets/images/on_boarding_images/sammy-line-no-connection.gif'),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
      ],
      showSkipButton: true,
      skip: Text('Skip'),
      next: Text('Next'),
      done: Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () {
        // Set flag that onboarding is completed and navigate
        _onIntroEnd();
      },
      onSkip: () {
        // Set flag that onboarding is completed and navigate
        _onIntroEnd();
      },
      skipOrBackFlex: 0,
      nextFlex: 0,
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
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
      print('Error during onboarding completion: $e');
      // Fallback navigation if there's an error
      Get.offAllNamed(Routes.LOGIN);
    }
  }
} 