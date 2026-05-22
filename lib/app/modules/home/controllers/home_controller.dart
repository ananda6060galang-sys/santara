import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/recipe_model.dart';

import '../../favorite/controllers/favorite_controller.dart';
import '../../home/controllers/home_with_navbar_controller.dart';

import '../../recipe_detail/controllers/recipe_detail_controller.dart';
import '../../recipe_detail/views/recipe_detail_view.dart';

class HomeController extends GetxController {

  final searchController =
      TextEditingController();

  final searchFocusNode =
      FocusNode();

  final isSearchActive =
      false.obs;

  final favoriteRecipes =
      <String, bool>{}.obs;

  final supabase =
      Supabase.instance.client;

  // =====================================================
  // SEARCH SUGGESTIONS
  // =====================================================

  final searchSuggestions = [

    'Resep Rendang Padang',

    'Sambal 20 menit',

    'Jajanan khas Jawa Barat',

    'Pempek Palembang',

    'Rawon Surabaya',
  ];

  // =====================================================
  // FEATURED RECIPES
  // =====================================================

  final featuredRecipes =
      <RecipeModel>[].obs;

  // =====================================================
  // CATEGORY LIST
  // =====================================================

  final categoryList = [

    {
      'title': 'Makanan berat',

      'imagePath':
          'assets/makan_berat.png'
    },

    {
      'title': 'Lauk',

      'imagePath':
          'assets/lauk.png'
    },

    {
      'title': 'Sambal',

      'imagePath':
          'assets/sambal.png'
    },

    {
      'title': 'Minuman',

      'imagePath':
          'assets/minuman.png'
    },

    {
      'title': 'Makanan ringan',

      'imagePath':
          'assets/makananringan.png'
    },

    {
      'title': 'Jajanan',

      'imagePath':
          'assets/jajanan.png'
    },
  ];

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {

    super.onInit();

    searchFocusNode.addListener(() {

      isSearchActive.value =
          searchFocusNode.hasFocus;
    });

    getRecipes();
  }

  // =====================================================
  // GET RECIPES
  // =====================================================

  Future<void> getRecipes() async {

    try {

      final data =
          await supabase
              .from('recipes')
              .select('''
                *,
                categories(name)
              ''');

      featuredRecipes.value =

          data.map<RecipeModel>((item) {

            return RecipeModel.fromJson(item);

          }).toList();

      await _loadFavorites();
    }

    catch (e) {

      Get.snackbar(

        'Error',

        e.toString(),

        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // =====================================================
  // LOAD FAVORITES
  // =====================================================

  Future<void> _loadFavorites() async {

    for (final recipe
        in featuredRecipes) {

      final isFav =
          await isRecipeFavorited(
              recipe.title);

      favoriteRecipes[
          recipe.title] = isFav;
    }
  }

  // =====================================================
  // SEARCH
  // =====================================================

  void activateSearch() {

    isSearchActive.value =
        true;

    searchFocusNode
        .requestFocus();
  }

  void deactivateSearch() {

    isSearchActive.value =
        false;

    searchFocusNode
        .unfocus();
  }

  void selectSuggestion(
      String suggestion) {

    searchController.text =
        suggestion;

    deactivateSearch();
  }

  // =====================================================
  // GO TO DETAIL
  // =====================================================

  void goToRecipeDetail(
      RecipeModel recipe) {

    Get.to(

      () => RecipeDetailView(),

      arguments: recipe,

      binding: BindingsBuilder(() {

        Get.lazyPut<
            RecipeDetailController>(

          () =>
              RecipeDetailController(),
        );
      }),
    );
  }

  // =====================================================
  // GO TO CATEGORY
  // =====================================================

  void goToCategory(
      String categoryTitle) {

    final navController =
        Get.find<
            HomeWithNavbarController>();

    navController
        .selectedCategory.value =
            categoryTitle;

    navController
        .changeIndex(2);
  }

  // =====================================================
  // SHARE RECIPE
  // =====================================================

  void shareRecipe(
      RecipeModel recipe) {

    final text = '''

🍽️ ${recipe.title}

📍 Lokasi:
${recipe.location}

⏱️ Waktu:
${recipe.cookingTime} menit

Bagikan resep nusantara favorit kamu! 🇮🇩

''';

    Share.share(

      text,

      subject:
          'Resep ${recipe.title} - Santara',
    );
  }

  // =====================================================
  // FAVORITE
  // =====================================================

  Future<void> toggleFavoriteRecipe(
      RecipeModel recipe) async {

    final recipeData = {

      'id':
          recipe.id,

      'title':
          recipe.title,

      'imagePath':
          recipe.imageUrl,

      'location':
          recipe.location,

      'duration':
          '${recipe.cookingTime} menit',

      'description':
          recipe.description,
    };

    final result =
        await toggleFavorite(
            recipeData);

    favoriteRecipes[
        recipe.title] = result;

    Get.snackbar(

      result
          ? 'Ditambahkan'
          : 'Dihapus',

      result

          ? '${recipe.title} ditambahkan ke favorit'

          : '${recipe.title} dihapus dari favorit',

      snackPosition:
          SnackPosition.BOTTOM,

      backgroundColor:
          const Color(0xFF8B4513),

      colorText:
          Colors.white,

      duration:
          const Duration(seconds: 2),
    );
  }

  // =====================================================
  // CLOSE
  // =====================================================

  @override
  void onClose() {

    searchController.dispose();

    searchFocusNode.dispose();

    super.onClose();
  }
}