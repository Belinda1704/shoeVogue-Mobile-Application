import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../../../data/models/user_model.dart';

class UserListView extends GetView<UserController> {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditUserDialog(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return UserCard(
                user: user,
                onEdit: () => _showAddEditUserDialog(user: user),
                onDelete: () => _showDeleteDialog(user),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddEditUserDialog({UserModel? user}) {
    final emailController = TextEditingController(text: user?.email);
    final displayNameController = TextEditingController(text: user?.displayName);
    final phoneController = TextEditingController(text: user?.phoneNumber);
    final photoURLController = TextEditingController(text: user?.photoURL);
    
    // Address controllers
    final streetController = TextEditingController(text: user?.address['street']);
    final cityController = TextEditingController(text: user?.address['city']);
    final stateController = TextEditingController(text: user?.address['state']);
    final zipCodeController = TextEditingController(text: user?.address['zipCode']);
    final countryController = TextEditingController(text: user?.address['country']);

    Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user == null ? 'Add User' : 'Edit User',
                  style: Get.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: photoURLController,
                decoration: const InputDecoration(labelText: 'Photo URL'),
              ),
              const SizedBox(height: 16),
              const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Street'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: zipCodeController,
                decoration: const InputDecoration(labelText: 'ZIP Code'),
              ),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(labelText: 'Country'),
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
                      final address = {
                        'street': streetController.text,
                        'city': cityController.text,
                        'state': stateController.text,
                        'zipCode': zipCodeController.text,
                        'country': countryController.text,
                      };

                      if (user == null) {
                        await controller.createUser(
                          email: emailController.text,
                          displayName: displayNameController.text,
                          phoneNumber: phoneController.text,
                          photoURL: photoURLController.text,
                          address: address,
                        );
                      } else {
                        await controller.updateUser(
                          user.id!,
                          email: emailController.text,
                          displayName: displayNameController.text,
                          phoneNumber: phoneController.text,
                          photoURL: photoURLController.text,
                          address: address,
                        );
                      }
                      Get.back();
                    },
                    child: Text(user == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.deleteUser(user.id!);
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

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    Key? key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : null,
          child: user.photoURL == null
              ? Text(user.displayName[0].toUpperCase())
              : null,
        ),
        title: Text(user.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            if (user.phoneNumber != null)
              Text(user.phoneNumber!),
            Text('${user.address['city']}, ${user.address['country']}'),
          ],
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
        isThreeLine: true,
      ),
    );
  }
} 