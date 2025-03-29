import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Theme Settings
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'appearance'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
                Obx(() => SwitchListTile(
                  title: Text('dark_mode'.tr),
                  subtitle: Text(
                    controller.isDarkMode.value ? 'dark_mode_enabled'.tr : 'light_mode_enabled'.tr,
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                  value: controller.isDarkMode.value,
                  onChanged: (value) => controller.toggleTheme(),
                )),
              ],
            ),
          ),

          // App Settings
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'app_settings'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
                Obx(() => ListTile(
                  title: Text('language'.tr),
                  subtitle: Text(controller.currentLanguage.value),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showLanguageDialog(context),
                )),
                Obx(() => ListTile(
                  title: Text('currency'.tr),
                  subtitle: Text('${controller.currentCurrency.value} (${controller.getCurrencySymbol(controller.currentCurrency.value)})'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showCurrencyDialog(context),
                )),
              ],
            ),
          ),

          // About Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'about'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('app_version'.tr),
                  subtitle: const Text('1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.languages.length,
            itemBuilder: (context, index) {
              final language = controller.languages[index];
              return ListTile(
                title: Text(language['name']!),
                trailing: Obx(() => controller.currentLanguage.value == language['name']
                    ? const Icon(Icons.check, color: Colors.blue)
                    : const SizedBox()),
                onTap: () => controller.changeLanguage(language['name']!),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_currency'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.currencies.length,
            itemBuilder: (context, index) {
              final currency = controller.currencies[index];
              return ListTile(
                title: Text(currency['name']!),
                subtitle: Text('${currency['symbol']} (${currency['code']})'),
                trailing: Obx(() => controller.currentCurrency.value == currency['code']
                    ? const Icon(Icons.check, color: Colors.blue)
                    : const SizedBox()),
                onTap: () => controller.changeCurrency(currency['code']!),
              );
            },
          ),
        ),
      ),
    );
  }
} 