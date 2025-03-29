import 'package:get/get.dart';
import 'package:shoe_vogue/app/modules/auth/bindings/auth_binding.dart';
import 'package:shoe_vogue/app/modules/auth/views/login_view.dart';
import 'package:shoe_vogue/app/modules/auth/views/signup_view.dart';
import 'package:shoe_vogue/app/modules/auth/views/forgot_password_view.dart';
import 'package:shoe_vogue/app/modules/auth/controllers/forgot_password_controller.dart';
import 'package:shoe_vogue/app/modules/auth/views/email_verification_view.dart';
import 'package:shoe_vogue/app/modules/home/bindings/home_binding.dart';
import 'package:shoe_vogue/app/modules/home/views/home_view.dart';
import 'package:shoe_vogue/app/modules/profile/bindings/profile_binding.dart';
import 'package:shoe_vogue/app/modules/profile/views/profile_view.dart';
import 'package:shoe_vogue/app/modules/cart/bindings/cart_binding.dart';
import 'package:shoe_vogue/app/modules/cart/views/cart_view.dart';
import 'package:shoe_vogue/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:shoe_vogue/app/modules/favorites/views/favorites_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/order_success/views/order_success_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/addresses_view.dart';
import '../modules/profile/views/orders_view.dart';
import '../modules/profile/views/notifications_view.dart';
import '../modules/profile/views/privacy_view.dart';
import '../modules/profile/views/help_center_view.dart';
import '../modules/profile/views/about_us_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/auth/views/phone_auth_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: Routes.EMAIL_VERIFICATION,
      page: () => const EmailVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      children: [
        GetPage(
          name: Routes.PROFILE_EDIT,
          page: () => const EditProfileView(),
        ),
        GetPage(
          name: Routes.PROFILE_ADDRESSES,
          page: () => const AddressesView(),
        ),
        GetPage(
          name: Routes.PROFILE_ORDERS,
          page: () => const OrdersView(),
        ),
        GetPage(
          name: Routes.PROFILE_NOTIFICATIONS,
          page: () => const NotificationsView(),
        ),
        GetPage(
          name: Routes.PROFILE_PRIVACY,
          page: () => const PrivacyView(),
        ),
        GetPage(
          name: Routes.PROFILE_HELP,
          page: () => const HelpCenterView(),
        ),
        GetPage(
          name: Routes.PROFILE_ABOUT,
          page: () => const AboutUsView(),
        ),
      ],
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.ORDER_SUCCESS,
      page: () => const OrderSuccessView(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.PHONE_AUTH,
      page: () => const PhoneAuthView(),
    ),
    GetPage(
      name: Routes.VERIFY_OTP,
      page: () => const OTPVerificationView(),
    ),
  ];
} 