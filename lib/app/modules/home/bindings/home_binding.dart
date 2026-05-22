import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/home_with_navbar_controller.dart';

import '../../category/controllers/category_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../recipe_detail/controllers/recipe_detail_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeWithNavbarController>(
      () => HomeWithNavbarController(),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );

    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );

    Get.lazyPut<RecipeDetailController>(
      () => RecipeDetailController(),
    );
  }
}