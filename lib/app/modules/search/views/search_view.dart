import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_search_controller.dart';

class SearchView extends GetView<ProductSearchController> {
  SearchView({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for products...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                textController.clear();
                controller.searchQuery.value = '';
                controller.getAllProducts();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            controller.searchProducts(value);
          },
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final product = controller.searchResults[index];
            return buildProductCard(product);
          },
        );
      }),
    );
  }

  Widget buildProductCard(dynamic product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to product detail page
                Get.toNamed('/product-detail', arguments: product);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: getProductImage(product),
              ),
            ),
          ),
          
          // Product details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getProductName(product),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  getProductPrice(product),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Placeholder for favorite button
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'Favorites',
                          'Feature will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    
                    // Add to cart button
                    GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Add to Cart',
                          'Added ${getProductName(product)} to cart',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
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
    );
  }

  // Helper methods to safely access product properties
  Widget getProductImage(dynamic product) {
    try {
      if (product is Map) {
        return Image.asset(
          product['imageUrl'] ?? 'assets/images/placeholder.png',
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          product.imageUrl ?? 'assets/images/placeholder.png',
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      return Image.asset(
        'assets/images/placeholder.png',
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  String getProductName(dynamic product) {
    try {
      if (product is Map) {
        return product['name'] ?? 'Unknown Product';
      } else {
        return product.name ?? 'Unknown Product';
      }
    } catch (e) {
      return 'Unknown Product';
    }
  }

  String getProductPrice(dynamic product) {
    try {
      if (product is Map) {
        return '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}';
      } else {
        return '\$${(product.price ?? 0.0).toStringAsFixed(2)}';
      }
    } catch (e) {
      return '\$0.00';
    }
  }
} 