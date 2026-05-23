import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/recipe_model.dart';

import '../../favorite/controllers/favorite_controller.dart';
import '../../home/controllers/home_with_navbar_controller.dart';

class CategoryController extends GetxController {
  // state utama
  final currentCategoryIndex = 0.obs;

  final favoriteCache = <String, bool>{}.obs;

  final isLoading = true.obs;

  // supabase
  final supabase = Supabase.instance.client;

  // semua recipe
  final recipes = <RecipeModel>[].obs;

  // semua category
  final categories = <String>[].obs;

  // category aktif sekarang
  String get currentCategory {
    if (categories.isEmpty) {
      return '';
    }

    return categories[currentCategoryIndex.value];
  }

  // filter recipe sesuai category
  List<RecipeModel> get currentRecipes {
    return recipes
        .where(
          (recipe) =>
              recipe.category.trim().toLowerCase() ==
              currentCategory.trim().toLowerCase(),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();

    getCategories();

    getRecipes();
  }

  // ambil semua category
  Future<void> getCategories() async {
    isLoading.value = true;

    try {
      final data = await supabase.from('categories').select();

      // masukin category ke list
      categories.value = List<String>.from(
        data.map((item) => item['name'].toString()),
      );

      // ambil category yg dipilih dari home
      final navController = Get.find<HomeWithNavbarController>();

      final String? selectedCategory = navController.selectedCategory.value;

      // langsung buka category yg dipilih
      if (selectedCategory != null) {
        setCategory(selectedCategory);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ambil semua recipe
  Future<void> getRecipes() async {
    try {
      final data = await supabase.from('recipes').select('''
                *,
                categories(name)
              ''');

      recipes.value = data.map<RecipeModel>((item) {
        return RecipeModel.fromJson(item);
      }).toList();

      await _loadFavorites();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ganti category realtime
  void setCategory(String categoryName) {
    final index = categories.indexWhere(
      (category) =>
          category.trim().toLowerCase() == categoryName.trim().toLowerCase(),
    );

    if (index != -1) {
      currentCategoryIndex.value = index;
    }
  }

  // next category
  void nextCategory() {
    if (categories.isEmpty) {
      return;
    }

    currentCategoryIndex.value =
        (currentCategoryIndex.value + 1) % categories.length;
  }

  // prev category
  void prevCategory() {
    if (categories.isEmpty) {
      return;
    }

    currentCategoryIndex.value =
        (currentCategoryIndex.value - 1 + categories.length) %
        categories.length;
  }

  // load bookmark
  Future<void> _loadFavorites() async {
    for (final recipe in recipes) {
      final isFav = await isRecipeFavorited(recipe.title);

      favoriteCache[recipe.title] = isFav;
    }
  }

  // cek bookmark
  bool isFavorite(String title) {
    return favoriteCache[title] ?? false;
  }

  // bookmark recipe
  Future<void> toggleFavoriteRecipe(RecipeModel recipe) async {
    final recipeData = {
      'id': recipe.id,

      'title': recipe.title,

      'imagePath': recipe.imageUrl,

      'location': recipe.location,

      'duration': '${recipe.cookingTime} menit',

      'description': recipe.description,
    };

    final result = await toggleFavorite(recipeData);

    favoriteCache[recipe.title] = result;

    favoriteCache.refresh();

    Get.snackbar(
      '',

      result
          ? '${recipe.title} ditambahkan ke favorit'
          : '${recipe.title} dihapus dari favorit',

      snackPosition: SnackPosition.BOTTOM,

      backgroundColor: const Color(0xFF8B4513),

      colorText: const Color(0xFFFFFFFF),

      duration: const Duration(seconds: 2),

      titleText: const SizedBox.shrink(),
    );
  }

  // share recipe
  void shareRecipe(RecipeModel recipe) {
    final text =
        '''

🍽️ ${recipe.title}

📍 Lokasi:
${recipe.location}

⏱️ Waktu:
${recipe.cookingTime} menit

Bagikan resep nusantara favorit kamu! 🇮🇩

''';

    Share.share(text, subject: 'Resep ${recipe.title} - Santara');
  }
}
