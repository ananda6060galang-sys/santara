import 'package:get/get.dart';

import 'package:santara_application/app/modules/home/controllers/home_controller.dart';

import '../../category/controllers/category_controller.dart';

class HomeWithNavbarController extends GetxController {

  // posisi tab navbar
  final currentIndex = 0.obs;

  // category yg dipilih dari home
  final selectedCategory =
      RxnString();

  @override
  void onInit() {

    super.onInit();

    // ambil argument navigate
    final args = Get.arguments;

    if (args != null && args is Map) {

      currentIndex.value =

          args['initialIndex'] ?? 0;

      selectedCategory.value =

          args['selectedCategory'];
    }
  }

  // pindah tab navbar
  void changeIndex(int index) {

    currentIndex.value = index;

    // auto fokus search
    if (index == 1) {

      Future.delayed(

        const Duration(milliseconds: 100),

        () {

          if (Get.isRegistered<
              HomeController>()) {

            Get.find<HomeController>()
                .activateSearch();
          }
        },
      );
    }

    // refresh bookmark pas balik tab biar icon ga nyangkut
    if ((index == 0 || index == 1) &&
        Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshFavoriteStatus();
    }

    if (index == 2 &&
        Get.isRegistered<CategoryController>()) {
      Get.find<CategoryController>().refreshFavoriteStatus();
    }
  }

  // buka category sesuai yg dipencet
  void goToCategory(
      String categoryName) {

    // update category terbaru
    selectedCategory.value =
        categoryName;

    // update category page realtime
    if (Get.isRegistered<
        CategoryController>()) {

      final categoryController =

          Get.find<
              CategoryController>();

      // langsung update category aktif
      categoryController
          .setCategory(
              categoryName);
    }

    // pindah ke tab category
    changeIndex(2);
  }
}
