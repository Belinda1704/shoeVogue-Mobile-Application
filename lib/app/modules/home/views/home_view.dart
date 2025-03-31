import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/home_controller.dart';
import '../../cart/views/cart_view.dart';
import '../../favorites/views/favorites_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../utils/currency_formatter.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/banner_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          // Removing product management action
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'app_name'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'find_perfect_pair'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
              title: Text('home'.tr),
              onTap: () {
                Get.back();
                controller.changePage(0); // Home tab
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
              title: Text('all_products'.tr),
              onTap: () {
                controller.changeCategory('All');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
              title: Text('favorites'.tr),
              onTap: () {
                Get.back();
                controller.changePage(1); // Favorites tab
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.primary),
              title: Text('cart'.tr),
              onTap: () {
                Get.back();
                controller.changePage(2); // Cart tab
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
              title: const Text('AI Features'),
              subtitle: const Text('Size Finder & Virtual Try-On'),
              onTap: () {
                Get.back();
                Get.toNamed('/ai-features');
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              title: Text('profile'.tr),
              onTap: () {
                Get.back();
                controller.changePage(3); // Profile tab
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
              title: Text('settings'.tr),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.SETTINGS);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
              title: Text('about_us'.tr),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.PROFILE_ABOUT);
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
              title: Text('help_center'.tr),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.PROFILE_HELP);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support_outlined, color: Theme.of(context).colorScheme.primary),
              title: Text('contact_us'.tr),
              onTap: () {
                Get.back();
                // You can create a Contact Us page later and navigate to it
                Get.snackbar(
                  'contact_us'.tr,
                  'contact_feature_coming_soon'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
      body: GetX<HomeController>(
        builder: (controller) => IndexedStack(
          index: controller.currentIndex,
          children: [
            _buildMainHome(context, scaffoldKey),
            const FavoritesView(),
            const CartView(),
            const ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: GetX<HomeController>(
        builder: (controller) => NavigationBar(
          selectedIndex: controller.currentIndex,
          onDestinationSelected: controller.changePage,
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          height: 65,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                  color: controller.currentIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline,
                  color: controller.currentIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant),
              label: 'favorites'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined,
                  color: controller.currentIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant),
              label: 'cart'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline,
                  color: controller.currentIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHome(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          expandedHeight: 180,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          Expanded(
                            child: Text(
                              'ShoeVogue',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              // Navigate to notifications using direct class reference
                              Get.toNamed('/profile');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                readOnly: true, // Make it act as a button
                                onTap: () {
                                  // Navigate to search page
                                  Get.toNamed('/search');
                                },
                                decoration: InputDecoration(
                                  hintText: 'search_in_store'.tr,
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6)),
                                  border: InputBorder.none,
                                ),
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
          ),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            if (controller.isLoadingBanners) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (controller.banners.isEmpty) {
              return const SizedBox.shrink(); // No banners, no space taken
            }
            
            return _buildBannerCarousel(context);
          }),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'categories'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryCard(context, 'all'.tr, Icons.all_inclusive),
                      _buildCategoryCard(context, 'sneakers'.tr, Icons.directions_run),
                      _buildCategoryCard(context, 'formal'.tr, Icons.business_center),
                      _buildCategoryCard(context, 'sports'.tr, Icons.sports_soccer),
                      _buildCategoryCard(context, 'casual'.tr, Icons.weekend),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'popular_products'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Show all products
                      },
                      child: Text('view_all'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: GetX<HomeController>(
            builder: (controller) => SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProductCard(context, index),
                childCount: controller.filteredProducts.length,
              ),
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }

  Widget _buildBannerCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'special_offers'.tr,
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
            items: controller.banners.map((BannerModel banner) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      // Handle banner click - navigate based on action URL
                      if (banner.actionUrl != null && banner.actionUrl!.isNotEmpty) {
                        // Simple routing based on actionUrl
                        if (banner.actionUrl!.startsWith('/')) {
                          Get.toNamed(banner.actionUrl!);
                        }
                      }
                    },
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
                                      debugPrint('Error loading banner image: $error');
                                      return Container(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    banner.imageUrl,
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
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
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
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return GetX<HomeController>(
      builder: (controller) => GestureDetector(
        onTap: () => controller.changeCategory(title),
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          width: 90,
          decoration: BoxDecoration(
            color: controller.selectedCategory == title
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: controller.selectedCategory == title
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: controller.selectedCategory == title
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, int index) {
    final product = controller.filteredProducts[index];
    return GestureDetector(
      onTap: () => Get.toNamed('/product-detail', arguments: product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite icon overlay
            Expanded(
              child: Stack(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: product['imageUrl'] != null
                        ? Image.asset(
                            product['imageUrl'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: Center(
                                  child: Icon(
                                    Icons.shopping_bag,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                  ),
                  // Favorite button overlay
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          product['isFavorite'] == true 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                          color: product['isFavorite'] == true 
                              ? Colors.red 
                              : Colors.grey,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.toggleFavorite(product['id']);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Product details and add to cart
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyFormatter.formatPrice(product['price']),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Add to cart button
                      InkWell(
                        onTap: () {
                          controller.addToCart(product['id']);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 