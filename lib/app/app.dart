import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
    return hasCompletedOnboarding ? Routes.HOME : Routes.ONBOARDING;
  }

  @override
  Widget build(BuildContext context) {
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
          title: 'ShoeVogue',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: snapshot.data ?? Routes.ONBOARDING,
          getPages: AppPages.routes,
        );
      },
    );
  }
} 