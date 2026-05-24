import 'package:get/get.dart';

// SPLASH
import '../modules/splash/views/splash_view.dart';
import '../modules/splash/bindings/splash_binding.dart';

// LOGIN
import '../modules/login/views/login_view.dart';
import '../modules/login/bindings/login_binding.dart';

// SIGNUP
import '../modules/signup/views/signup_view.dart';
import '../modules/signup/bindings/signup_binding.dart';

// HOME
import '../modules/home/views/home_with_navbar_view.dart';
import '../modules/home/bindings/home_binding.dart';

// CATEGORY
import '../modules/category/views/category_view.dart';
import '../modules/category/bindings/category_binding.dart';

// FAVORITE
import '../modules/favorite/views/favorite_view.dart';
import '../modules/favorite/bindings/favorite_binding.dart';

// PROFILE
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';

// EDIT PROFILE
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';

// ACCOUNT INFO
import '../modules/account_info/views/account_info_view.dart';
import '../modules/account_info/bindings/account_info_binding.dart';

// ACCOUNT SECURITY
import '../modules/account_security/views/account_security_view.dart';
import '../modules/account_security/bindings/account_security_binding.dart';

// RECIPE DETAIL
import '../modules/recipe_detail/views/recipe_detail_view.dart';
import '../modules/recipe_detail/bindings/recipe_detail_binding.dart';

// HISTORY
import '../modules/history/views/history_view.dart';
import '../modules/history/bindings/history_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // halaman pertama pas app dibuka
  static const INITIAL = Routes.SPLASH;

  // daftar semua route yang dipakai GetX
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => const HomeWithNavbar(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.CATEGORY,
      page: () => const CategoryPage(),
      binding: CategoryBinding(),
    ),

    GetPage(
      name: Routes.FAVORITE,
      page: () => const Favoriteview(),
      binding: FavoriteBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfilePage(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: Routes.ACCOUNT_INFO,
      page: () => const InfoAkunPage(),
      binding: InfoAkunBinding(),
    ),

    GetPage(
      name: Routes.ACCOUNT_SECURITY,
      page: () => const KeamananAkunPage(),
      binding: KeamananAkunBinding(),
    ),

    GetPage(
      name: Routes.RECIPE_DETAIL,
      page: () => const RecipeDetailView(),
      binding: RecipeDetailBinding(),
    ),

    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),
  ];
}
