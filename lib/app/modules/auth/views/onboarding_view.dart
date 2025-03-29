import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class OnboardingView extends GetView<AuthController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OnboardingItem> items = [
      OnboardingItem(
        title: 'Shop in Style',
        description: 'Explore our exclusive collection of trendy footwear. Find the perfect pair that matches your unique style.',
        image: 'assets/images/on_boarding_images/sammy-line-shopping.gif',
      ),
      OnboardingItem(
        title: 'Smart Search',
        description: 'Use our intelligent search to filter by style, size, brand, or price to find your dream shoes quickly.',
        image: 'assets/images/on_boarding_images/sammy-line-searching.gif',
      ),
      OnboardingItem(
        title: 'Swift Delivery',
        description: 'Enjoy fast and reliable delivery right to your doorstep. Track your order in real-time.',
        image: 'assets/images/on_boarding_images/sammy-line-delivery.gif',
      ),
      OnboardingItem(
        title: 'Shop Anywhere',
        description: 'Our app works seamlessly online and offline. Never miss out on your favorite shoes, even with poor connectivity.',
        image: 'assets/images/on_boarding_images/sammy-line-no-connection.gif',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: items.length,
            onPageChanged: (index) => controller.setCurrentPage(index),
            itemBuilder: (context, index) {
              return OnboardingPage(item: items[index]);
            },
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: controller.currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.setFirstTime(false);
                      Get.offAllNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    controller.setFirstTime(false);
                    Get.offAllNamed('/login');
                  },
                  child: const Text('Skip'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            item.image,
            height: 300,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
} 