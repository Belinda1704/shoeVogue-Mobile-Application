import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  final RxBool isDarkMode = false.obs;
  final RxString currentLanguage = 'English'.obs;
  final RxString currentCurrency = 'USD'.obs;

  // Available languages
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Italian', 'code': 'it'},
    {'name': 'Portuguese', 'code': 'pt'},
  ];

  // Available currencies
  final List<Map<String, String>> currencies = [
    {'name': 'US Dollar', 'code': 'USD', 'symbol': '\$'},
    {'name': 'Euro', 'code': 'EUR', 'symbol': '€'},
    {'name': 'British Pound', 'code': 'GBP', 'symbol': '£'},
    {'name': 'Japanese Yen', 'code': 'JPY', 'symbol': '¥'},
    {'name': 'Canadian Dollar', 'code': 'CAD', 'symbol': 'CA\$'},
    {'name': 'Australian Dollar', 'code': 'AUD', 'symbol': 'AU\$'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
    loadLanguage();
    loadCurrency();
    _initializeLocale();
  }

  void _initializeLocale() {
    final savedLanguage = _storage.read('language') ?? 'English';
    final languageCode = languages.firstWhere(
      (lang) => lang['name'] == savedLanguage,
      orElse: () => languages[0],
    )['code']!;
    
    Get.updateLocale(Locale(languageCode));
  }

  void loadThemeMode() {
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void loadLanguage() {
    currentLanguage.value = _storage.read('language') ?? 'English';
  }

  void loadCurrency() {
    currentCurrency.value = _storage.read('currency') ?? 'USD';
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLanguage(String language) {
    currentLanguage.value = language;
    _storage.write('language', language);
    
    // Update app locale
    final languageCode = languages.firstWhere(
      (lang) => lang['name'] == language,
      orElse: () => languages[0],
    )['code']!;
    
    // Log information for debugging
    debugPrint('Changing language to: $language (code: $languageCode)');
    
    Get.updateLocale(Locale(languageCode));
    
    // Refresh UI to ensure all translations are updated
    Future.delayed(Duration(milliseconds: 100), () {
      Get.forceAppUpdate();
    });
    
    Get.back();
  }

  void changeCurrency(String currency) {
    currentCurrency.value = currency;
    _storage.write('currency', currency);
    Get.back();
  }

  String getCurrencySymbol(String currencyCode) {
    final currency = currencies.firstWhere(
      (c) => c['code'] == currencyCode,
      orElse: () => {'symbol': '\$'},
    );
    return currency['symbol'] ?? '\$';
  }

  String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      symbol: getCurrencySymbol(currentCurrency.value),
      decimalDigits: currentCurrency.value == 'JPY' ? 0 : 2,
    );
    return format.format(amount);
  }

  // Helper method to get language name from code
  String getLanguageName(String code) {
    final language = languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => languages[0],
    );
    return language['name']!;
  }

  // Helper method to get currency name from code
  String getCurrencyName(String code) {
    final currency = currencies.firstWhere(
      (curr) => curr['code'] == code,
      orElse: () => currencies[0],
    );
    return currency['name']!;
  }
} 