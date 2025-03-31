import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_features_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class AiFeaturesView extends GetView<AiFeaturesController> {
  const AiFeaturesView({Key? key}) : super(key: key);

  final List<Map<String, String>> shoes = const [
    {'name': 'Nike Air Max', 'image': 'assets/images/products/NikeAirMax.png'},
    {'name': 'Air Jordan Orange', 'image': 'assets/images/products/NikeAirJOrdonOrange.png'},
    {'name': 'Nike Wildhorse', 'image': 'assets/images/products/NikeWildhorse.png'},
    {'name': 'Air Jordan Blue', 'image': 'assets/images/products/NikeAirJordonSingleBlue.png'},
    {'name': 'Nike Basketball', 'image': 'assets/images/products/NikeBasketballShoeGreenBlack.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Features'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFootSizeSection(),
            const SizedBox(height: 24),
            _buildVirtualTryOnSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFootSizeSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Foot Size Measurement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Get your accurate foot size measurement using our AI technology.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Obx(() => controller.footSize.value.isNotEmpty
                ? Text(
                    'Your foot size: ${controller.footSize.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox()),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: controller.isProcessing.value
                      ? null
                      : () => controller.measureFootSize(),
                  child: controller.isProcessing.value
                      ? const CircularProgressIndicator()
                      : const Text('Measure Foot Size'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualTryOnSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Virtual Try-On',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Try on shoes virtually using your camera.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a shoe to try on:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shoes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.selectedShoeImage.value = shoes[index]['image']!;
                    },
                    child: Obx(() => Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.selectedShoeImage.value == shoes[index]['image']
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: controller.selectedShoeImage.value == shoes[index]['image'] ? 2.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                              child: Image.asset(
                                shoes[index]['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.error_outline, color: Colors.red[300]),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              shoes[index]['name']!,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => controller.selectedShoeImage.value.isNotEmpty
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        controller.selectedShoeImage.value,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                                const SizedBox(height: 8),
                                const Text('Failed to load image'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Select a shoe to try on'),
                    ),
                  )),
            const SizedBox(height: 16),
            Obx(() => controller.virtualTryOnImage.value.isNotEmpty
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(controller.virtualTryOnImage.value),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                                const SizedBox(height: 8),
                                const Text('Failed to load image'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox()),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: controller.selectedShoeImage.value.isEmpty || controller.isProcessing.value
                      ? null
                      : () => controller.virtualTryOn(controller.selectedShoeImage.value),
                  child: controller.isProcessing.value
                      ? const CircularProgressIndicator()
                      : const Text('Try On Selected Shoe'),
                )),
          ],
        ),
      ),
    );
  }
} 