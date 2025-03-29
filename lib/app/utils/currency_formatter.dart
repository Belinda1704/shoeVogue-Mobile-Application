import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatPrice(double price) {
    final storage = GetStorage();
    final currency = storage.read('currency') ?? 'USD';
    
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'CA\$',
      'AUD': 'AU\$',
    };

    final rates = {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'JPY': 149.50,
      'CAD': 1.35,
      'AUD': 1.53,
    };

    final convertedPrice = price * (rates[currency] ?? 1.0);
    final symbol = symbols[currency] ?? '\$';
    
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: currency == 'JPY' ? 0 : 2,
    );

    return formatter.format(convertedPrice);
  }
} 