import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class AddressesView extends GetView<ProfileController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.addresses.length,
        itemBuilder: (context, index) {
          final address = controller.addresses[index];
          final isDefault = address['isDefault'] == 'true';
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            address['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isDefault)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditAddressDialog(context, address);
                          } else if (value == 'delete') {
                            controller.deleteAddress(address['id']!);
                          } else if (value == 'default') {
                            // TODO: Set as default
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          if (!isDefault)
                            const PopupMenuItem(
                              value: 'default',
                              child: Text('Set as Default'),
                            ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(address['address'] ?? ''),
                  Text(
                    '${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['zipCode'] ?? ''}',
                  ),
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () => _showAddAddressDialog(context),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final titleController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final zipCodeController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Add New Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g., Home, Work)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  addressController.text.isEmpty ||
                  cityController.text.isEmpty ||
                  stateController.text.isEmpty ||
                  zipCodeController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please fill in all fields',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              
              controller.addAddress({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'title': titleController.text,
                'address': addressController.text,
                'city': cityController.text,
                'state': stateController.text,
                'zipCode': zipCodeController.text,
                'isDefault': controller.addresses.isEmpty ? 'true' : 'false',
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, Map<String, String> address) {
    final titleController = TextEditingController(text: address['title']);
    final addressController = TextEditingController(text: address['address']);
    final cityController = TextEditingController(text: address['city']);
    final stateController = TextEditingController(text: address['state']);
    final zipCodeController = TextEditingController(text: address['zipCode']);
    
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g., Home, Work)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  addressController.text.isEmpty ||
                  cityController.text.isEmpty ||
                  stateController.text.isEmpty ||
                  zipCodeController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please fill in all fields',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              
              controller.updateAddress(address['id']!, {
                'id': address['id']!,
                'title': titleController.text,
                'address': addressController.text,
                'city': cityController.text,
                'state': stateController.text,
                'zipCode': zipCodeController.text,
                'isDefault': address['isDefault']!,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 