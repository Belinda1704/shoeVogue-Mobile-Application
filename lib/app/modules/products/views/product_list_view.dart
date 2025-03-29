import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../../data/models/product_model.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditProductDialog(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return ProductCard(
                product: product,
                onEdit: () => _showAddEditProductDialog(product: product),
                onDelete: () => _showDeleteDialog(product),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddEditProductDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name);
    final descriptionController = TextEditingController(text: product?.description);
    final priceController = TextEditingController(text: product?.price.toString() ?? '0.0');
    final imageUrlController = TextEditingController(text: product?.imageUrl);
    final stockController = TextEditingController(text: product?.stock.toString() ?? '0');
    final brandController = TextEditingController(text: product?.brand);
    final categoryController = TextEditingController(text: product?.category);
    final featuresController = TextEditingController(text: product?.features.join('\n'));
    final sizesController = TextEditingController(text: product?.sizes.join(', '));
    final colorsController = TextEditingController(text: product?.colors.join(', '));
    final ratingController = TextEditingController(text: product?.rating.toString() ?? '0.0');
    final reviewCountController = TextEditingController(text: product?.reviewCount.toString() ?? '0');

    Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product == null ? 'Add Product' : 'Edit Product',
                  style: Get.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Main Image URL'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: featuresController,
                decoration: const InputDecoration(
                  labelText: 'Features',
                  helperText: 'Enter each feature on a new line',
                ),
                maxLines: 3,
              ),
              TextField(
                controller: sizesController,
                decoration: const InputDecoration(
                  labelText: 'Sizes',
                  helperText: 'Enter sizes separated by commas',
                ),
              ),
              TextField(
                controller: colorsController,
                decoration: const InputDecoration(
                  labelText: 'Colors',
                  helperText: 'Enter colors separated by commas',
                ),
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: reviewCountController,
                decoration: const InputDecoration(labelText: 'Review Count'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (product == null) {
                        await controller.createProduct(
                          name: nameController.text,
                          description: descriptionController.text,
                          price: double.tryParse(priceController.text) ?? 0.0,
                          imageUrl: imageUrlController.text,
                          stock: int.tryParse(stockController.text) ?? 0,
                          brand: brandController.text,
                          category: categoryController.text,
                          features: featuresController.text.split('\n').where((s) => s.isNotEmpty).toList(),
                          sizes: sizesController.text.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList(),
                          colors: colorsController.text.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList(),
                          rating: double.tryParse(ratingController.text) ?? 0.0,
                          reviewCount: int.tryParse(reviewCountController.text) ?? 0,
                        );
                      } else {
                        await controller.updateProduct(
                          product.id!,
                          name: nameController.text,
                          description: descriptionController.text,
                          price: double.tryParse(priceController.text),
                          imageUrl: imageUrlController.text,
                          stock: int.tryParse(stockController.text),
                          brand: brandController.text,
                          category: categoryController.text,
                          features: featuresController.text.split('\n').where((s) => s.isNotEmpty).toList(),
                          sizes: sizesController.text.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList(),
                          colors: colorsController.text.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList(),
                          rating: double.tryParse(ratingController.text),
                          reviewCount: int.tryParse(reviewCountController.text),
                        );
                      }
                      Get.back();
                    },
                    child: Text(product == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.deleteProduct(product.id!);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              )
            : const Icon(Icons.image),
        title: Text(product.name),
        subtitle: Text(
          '${product.description}\nPrice: \$${product.price.toStringAsFixed(2)} | Stock: ${product.stock}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
} 