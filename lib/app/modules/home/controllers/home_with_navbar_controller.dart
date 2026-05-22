import 'package:get/get.dart';
import 'package:santara_application/app/modules/home/controllers/home_controller.dart';

class HomeWithNavbarController extends GetxController {
  final currentIndex = 0.obs;
  final selectedCategory = RxnString(); // nullable String

  // Terima initialIndex & selectedCategory dari arguments
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      currentIndex.value    = args['initialIndex'] ?? 0;
      selectedCategory.value = args['selectedCategory'];
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;

    // Aktifkan search saat pindah ke tab search (index 1)
    if (index == 1) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().activateSearch();
        }
      });
    }
  }
}