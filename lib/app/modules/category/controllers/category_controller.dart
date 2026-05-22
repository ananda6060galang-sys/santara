import 'dart:ui';

import 'package:flutter/material.dart' show SizedBox;
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/recipe_model.dart';

import '../../favorite/controllers/favorite_controller.dart';

class CategoryController extends GetxController {

  // =====================================================
  // STATE
  // =====================================================

  final RxInt currentCategoryIndex =
      0.obs;

  final RxMap<String, bool>
      favoriteCache =
          <String, bool>{}.obs;

  // =====================================================
  // CATEGORY LIST
  // =====================================================

  final List<String> categories = [

    'Makanan berat',

    'Lauk',

    'Sambal',

    'Minuman',

    'Makanan ringan',

    'Jajanan',
  ];

  // =====================================================
  // DUMMY RECIPES
  // =====================================================

  final Map<String, List<RecipeModel>>
      recipesByCategory = {

    // =====================================================
    // MAKANAN BERAT
    // =====================================================

    'Makanan berat': [

      RecipeModel(

        id: '1',

        title: 'Nasi Kuning',

        description:
            'Nasi kuning khas nusantara.',

        imageUrl:
            'makan_berat.png',

        location:
            'Jawa Timur',

        cookingTime:
            60,

        category:
            'Makanan berat',

        ingredients:
            '',

        steps:
            '',

        servings:
            6,

        difficulty:
            'Sedang',
      ),

      RecipeModel(

        id: '2',

        title: 'Rawon',

        description:
            'Rawon khas Jawa Timur.',

        imageUrl:
            'makan_berat2.png',

        location:
            'Jawa Timur',

        cookingTime:
            45,

        category:
            'Makanan berat',

        ingredients:
            '',

        steps:
            '',

        servings:
            5,

        difficulty:
            'Sedang',
      ),
    ],

    // =====================================================
    // LAUK
    // =====================================================

    'Lauk': [

      RecipeModel(

        id: '3',

        title: 'Rendang',

        description:
            'Rendang khas Padang.',

        imageUrl:
            'lauk1.png',

        location:
            'Sumatra Barat',

        cookingTime:
            120,

        category:
            'Lauk',

        ingredients:
            '',

        steps:
            '',

        servings:
            8,

        difficulty:
            'Sulit',
      ),
    ],

    // =====================================================
    // SAMBAL
    // =====================================================

    'Sambal': [

      RecipeModel(

        id: '4',

        title:
            'Sambal Matah',

        description:
            'Sambal khas Bali.',

        imageUrl:
            'sambal1.png',

        location:
            'Bali',

        cookingTime:
            20,

        category:
            'Sambal',

        ingredients:
            '',

        steps:
            '',

        servings:
            3,

        difficulty:
            'Mudah',
      ),
    ],

    // =====================================================
    // MINUMAN
    // =====================================================

    'Minuman': [

      RecipeModel(

        id: '5',

        title:
            'Es Cendol',

        description:
            'Minuman segar khas Jawa Barat.',

        imageUrl:
            'minum1.png',

        location:
            'Jawa Barat',

        cookingTime:
            10,

        category:
            'Minuman',

        ingredients:
            '',

        steps:
            '',

        servings:
            4,

        difficulty:
            'Mudah',
      ),
    ],

    // =====================================================
    // MAKANAN RINGAN
    // =====================================================

    'Makanan ringan': [

      RecipeModel(

        id: '6',

        title:
            'Mendoan',

        description:
            'Tempe mendoan khas Banyumas.',

        imageUrl:
            'ringan1.png',

        location:
            'Jawa Tengah',

        cookingTime:
            20,

        category:
            'Makanan ringan',

        ingredients:
            '',

        steps:
            '',

        servings:
            4,

        difficulty:
            'Mudah',
      ),
    ],

    // =====================================================
    // JAJANAN
    // =====================================================

    'Jajanan': [

      RecipeModel(

        id: '7',

        title:
            'Klepon',

        description:
            'Klepon isi gula merah.',

        imageUrl:
            'jajanan6.png',

        location:
            'Jawa Tengah',

        cookingTime:
            15,

        category:
            'Jajanan',

        ingredients:
            '',

        steps:
            '',

        servings:
            5,

        difficulty:
            'Mudah',
      ),
    ],
  };

  // =====================================================
  // GETTERS
  // =====================================================

  String get currentCategory =>

      categories[
          currentCategoryIndex.value];

  List<RecipeModel>
      get currentRecipes =>

          recipesByCategory[
              currentCategory]!;
  
  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {

    super.onInit();

    final String?
        selectedCategory =

            Get.arguments
                as String?;

    if (selectedCategory != null) {

      final index =
          categories.indexOf(
              selectedCategory);

      if (index != -1) {

        currentCategoryIndex.value =
            index;
      }
    }

    _loadFavorites();
  }

  // =====================================================
  // CATEGORY NAVIGATION
  // =====================================================

  void nextCategory() {

    currentCategoryIndex.value =

        (currentCategoryIndex.value + 1)

            % categories.length;
  }

  void prevCategory() {

    currentCategoryIndex.value =

        (currentCategoryIndex.value - 1

            + categories.length)

            % categories.length;
  }

  // =====================================================
  // FAVORITES
  // =====================================================

  Future<void> _loadFavorites()
  async {

    for (final categoryRecipes
        in recipesByCategory.values) {

      for (final recipe
          in categoryRecipes) {

        final isFav =

            await isRecipeFavorited(
                recipe.title);

        favoriteCache[
            recipe.title] = isFav;
      }
    }
  }

  bool isFavorite(String title) =>

      favoriteCache[title]
          ?? false;

  Future<void>
      toggleFavoriteRecipe(
          RecipeModel recipe)
  async {

    final recipeData = {

      'id':
          recipe.id,

      'title':
          recipe.title,

      'imagePath':
          'assets/${recipe.imageUrl}',

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

    favoriteCache[
        recipe.title] = result;

    Get.snackbar(

      '',

      result

          ? '${recipe.title} ditambahkan ke favorit'

          : '${recipe.title} dihapus dari favorit',

      snackPosition:
          SnackPosition.BOTTOM,

      backgroundColor:
          const Color(0xFF8B4513),

      colorText:
          const Color(0xFFFFFFFF),

      duration:
          const Duration(seconds: 2),

      titleText:
          const SizedBox.shrink(),
    );
  }

  // =====================================================
  // SHARE
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
}