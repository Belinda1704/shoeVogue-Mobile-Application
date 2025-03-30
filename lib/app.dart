import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/search/bindings/search_binding.dart';
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/cart/bindings/cart_binding.dart';
import 'app/modules/favorites/bindings/favorites_binding.dart';
import 'app/modules/profile/bindings/profile_binding.dart';
import 'app/modules/settings/bindings/settings_binding.dart';
import 'app/theme/app_theme.dart';
import 'app/translations/app_translations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import other bindings you need

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    FavoritesBinding().dependencies();
    HomeBinding().dependencies();
    CartBinding().dependencies();
    SearchBinding().dependencies();
    ProfileBinding().dependencies();
    SettingsBinding().dependencies();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  String _getLanguageCode(String savedLanguage) {
    final Map<String, String> languageMap = {
      'English': 'en',
      'Spanish': 'es',
      'Español': 'es',
      'French': 'fr',
      'Français': 'fr',
      'German': 'de',
      'Deutsch': 'de',
      'Italian': 'it',
      'Portuguese': 'pt',
    };
    
    return languageMap[savedLanguage] ?? 'en';
  }

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
    return hasCompletedOnboarding ? Routes.HOME : Routes.ONBOARDING;
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final savedLanguage = storage.read('language') ?? 'English';
    final languageCode = _getLanguageCode(savedLanguage);
    final isDarkMode = storage.read('isDarkMode') ?? false;

    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return GetMaterialApp(
          title: 'ShoeVogue'.tr,
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: Locale(languageCode),
          fallbackLocale: const Locale('en'),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                physics: const BouncingScrollPhysics(),
              ),
              child: child!,
            );
          },
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: snapshot.data ?? Routes.ONBOARDING,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
