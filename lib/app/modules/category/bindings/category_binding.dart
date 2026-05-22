import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../../recipe_detail/controllers/recipe_detail_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
    
    Get.lazyPut<RecipeDetailController>(
      () => RecipeDetailController(),
    );
  }
}