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
  // =====================================================
  // CONTROLLER SEARCH
  // buat nyimpen text search
  // =====================================================

  final searchController = TextEditingController();

  // =====================================================
  // FOCUS NODE SEARCH
  // detect search lagi aktif apa ngga
  // =====================================================

  final searchFocusNode = FocusNode();

  // =====================================================
  // STATUS SEARCH
  // true = search kebuka
  // false = search ketutup
  // =====================================================

  final isSearchActive = false.obs;

  // =====================================================
  // LOADING
  // buat shimmer loading tadi
  // =====================================================

  final isLoading = true.obs;

  // =====================================================
  // FAVORITE CACHE
  // nyimpen status bookmark
  // =====================================================

  final favoriteRecipes = <String, bool>{}.obs;

  // =====================================================
  // SUPABASE CLIENT
  // koneksi database
  // =====================================================

  final supabase = Supabase.instance.client;

  // =====================================================
  // SEARCH SUGGESTIONS
  // suggestion pas search diklik
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
  // list resep dari database
  // =====================================================

  final featuredRecipes = <RecipeModel>[].obs;

  // =====================================================
  // CATEGORY LIST
  // category realtime dari database
  // =====================================================

  final categoryList = <Map<String, dynamic>>[].obs;

  // =====================================================
  // INIT
  // pertama kali controller jalan
  // =====================================================

  @override
  void onInit() {
    super.onInit();

    // detect search focus
    searchFocusNode.addListener(() {
      isSearchActive.value = searchFocusNode.hasFocus;
    });

    // ambil data recipe
    getRecipes();
  }

  // =====================================================
  // GET RECIPES
  // fetch resep dari supabase
  // =====================================================

  Future<void> getRecipes() async {
    // loading nyala dulu
    isLoading.value = true;

    try {
      final data = await supabase.from('recipes').select('''
                *,
                categories(name)
              ''');

      // masukin data ke list recipe
      featuredRecipes.value = data.map<RecipeModel>((item) {
        return RecipeModel.fromJson(item);
      }).toList();

      // load status favorite
      await _loadFavorites();
      await getCategories();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      // loading dimatiin
      isLoading.value = false;
    }
  }

  // =====================================================
  // GET CATEGORIES
  // ambil category + image dari database
  // =====================================================

  Future<void> getCategories() async {
    try {
      final data = await supabase.from('categories').select();

      // masukin category ke list
      categoryList.value = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      Get.snackbar(
        'Error Category',

        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =====================================================
  // LOAD FAVORITES
  // ngecek recipe mana aja yg dibookmark
  // =====================================================

  Future<void> _loadFavorites() async {
    for (final recipe in featuredRecipes) {
      final isFav = await isRecipeFavorited(recipe.title);

      favoriteRecipes[recipe.title] = isFav;
    }
  }

  // =====================================================
  // AKTIFIN SEARCH
  // =====================================================

  void activateSearch() {
    isSearchActive.value = true;

    searchFocusNode.requestFocus();
  }

  // =====================================================
  // MATIIN SEARCH
  // =====================================================

  void deactivateSearch() {
    isSearchActive.value = false;

    searchFocusNode.unfocus();
  }

  // =====================================================
  // PAS SUGGESTION DIKLIK
  // =====================================================

  void selectSuggestion(String suggestion) {
    searchController.text = suggestion;

    deactivateSearch();
  }

  // =====================================================
  // PINDAH KE DETAIL RESEP
  // =====================================================

  void goToRecipeDetail(RecipeModel recipe) {
    Get.to(
      () => RecipeDetailView(),

      arguments: recipe,

      binding: BindingsBuilder(() {
        Get.lazyPut<RecipeDetailController>(() => RecipeDetailController());
      }),
    );
  }

  // =====================================================
  // PINDAH KE CATEGORY
  // =====================================================

  void goToCategory(String categoryTitle) {
    final navController = Get.find<HomeWithNavbarController>();

    navController.selectedCategory.value = categoryTitle;

    navController.changeIndex(2);
  }

  // =====================================================
  // SHARE RECIPE
  // buat share resep
  // =====================================================

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

  // =====================================================
  // FAVORITE
  // bookmark recipe
  // =====================================================

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

    favoriteRecipes[recipe.title] = result;

    // refresh biar icon langsung update
    favoriteRecipes.refresh();

    Get.snackbar(
      result ? 'Ditambahkan' : 'Dihapus',

      result
          ? '${recipe.title} ditambahkan ke favorit'
          : '${recipe.title} dihapus dari favorit',

      snackPosition: SnackPosition.BOTTOM,

      backgroundColor: const Color(0xFF8B4513),

      colorText: Colors.white,

      duration: const Duration(seconds: 2),
    );
  }

  // =====================================================
  // CLOSE
  // dispose controller biar aman memory
  // =====================================================

  @override
  void onClose() {
    searchController.dispose();

    searchFocusNode.dispose();

    super.onClose();
  }
}
