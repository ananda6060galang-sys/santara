import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/recipe_model.dart';

import '../../favorite/controllers/favorite_controller.dart';
import '../../history/controllers/history_controller.dart';

class RecipeDetailController extends GetxController {

  // =====================================================
  // RECIPE
  // =====================================================

  late RecipeModel recipe;

  // =====================================================
  // STATE
  // =====================================================

  final isFavorited = false.obs;

  // =====================================================
  // GETTERS
  // =====================================================

  List<String> get ingredientsList =>
      recipe.ingredients
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();

  List<String> get stepsList =>
      recipe.steps
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {

    super.onInit();

    recipe =
        Get.arguments as RecipeModel;

    Future.delayed(
      Duration.zero,

      () {

        _checkFavoriteStatus();

        _saveToHistory();
      },
    );
  }

  // =====================================================
  // SAVE HISTORY
  // =====================================================

  Future<void> _saveToHistory() async {

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
    };

    await addToHistory(recipeData);
  }

  // =====================================================
  // CHECK FAVORITE
  // =====================================================

  Future<void> _checkFavoriteStatus() async {

    final favorited =
        await isRecipeFavorited(
            recipe.id);

    isFavorited.value =
        favorited;
  }

  // =====================================================
  // TOGGLE FAVORITE
  // =====================================================

  Future<void> toggleFavoriteStatus() async {

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

    final nowFavorited =
        await toggleFavorite(
            recipeData);

    isFavorited.value =
        nowFavorited;

    Get.snackbar(

      nowFavorited
          ? 'Ditambahkan'
          : 'Dihapus',

      nowFavorited

          ? '${recipe.title} ditambahkan ke koleksi'

          : '${recipe.title} dihapus dari koleksi',

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
  // SHARE RECIPE
  // =====================================================

  void shareRecipe() {

    final text = '''

🍽️ ${recipe.title}

${recipe.description}

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
