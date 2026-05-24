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
  Worker? _favoriteWorker;

  // =====================================================
  // CONTROLLER SEARCH
  // buat nyimpen text search
  // =====================================================

  TextEditingController? _searchController;

  TextEditingController get searchController {
    return _searchController ??= TextEditingController();
  }

  // =====================================================
  // FOCUS NODE SEARCH
  // detect search lagi aktif apa ngga
  // =====================================================

  FocusNode? _searchFocusNode;

  FocusNode get searchFocusNode {
    if (_searchFocusNode == null) {
      _searchFocusNode = FocusNode();
      _searchFocusNode!.addListener(_searchFocusListener);
    }

    return _searchFocusNode!;
  }

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

  final searchQuery = ''.obs;

  final searchResults = <RecipeModel>[].obs;

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
    searchFocusNode;

    // realtime search pas user ngetik
    searchController.addListener(_onSearchChanged);

    // kalau koleksi berubah, icon bookmark ikut refresh
    if (Get.isRegistered<FavoriteController>()) {
      final favoriteController = Get.find<FavoriteController>();

      _favoriteWorker = ever(favoriteController.favorites, (_) {
        _loadFavorites();
      });
    }

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

      _filterSearchResults(searchQuery.value);

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
      final isFav = await isRecipeFavorited(recipe.id);

      favoriteRecipes[recipe.id] = isFav;
    }
  }

  Future<void> refreshFavoriteStatus() async {
    await _loadFavorites();
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

    _filterSearchResults(suggestion);

    isSearchActive.value = false;

    searchFocusNode.unfocus();
  }

  void selectSearchRecipe(RecipeModel recipe) {
    deactivateSearch();

    searchController.clear();

    goToRecipeDetail(recipe);
  }

  void onMicTap() {
    Get.snackbar(
      'Info',
      'Fitur voice search belum tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;

    _filterSearchResults(searchQuery.value);
  }

  void _filterSearchResults(String query) {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      searchResults.clear();
      return;
    }

    // pecah keyword biar rekomendasi kayak "Resep Rendang Padang" tetap nyantol
    final keywords = keyword
        .split(' ')
        .where((word) => word.isNotEmpty && word != 'resep')
        .toList();
    final cleanKeyword = keywords.join(' ');

    searchResults.value = featuredRecipes.where((recipe) {
      final searchableText =
          '${recipe.title} ${recipe.category} ${recipe.location} '
                  '${recipe.description} ${recipe.cookingTime} menit'
              .toLowerCase();

      // kalau phrase lengkap ga ada, minimal salah satu kata penting tetap dicari
      return searchableText.contains(cleanKeyword) ||
          keywords.any(searchableText.contains);
    }).toList();
  }

  void _searchFocusListener() {
    final focusNode = _searchFocusNode;

    if (focusNode == null) return;

    isSearchActive.value = focusNode.hasFocus;
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

    favoriteRecipes[recipe.id] = result;

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
    _favoriteWorker?.dispose();

    _searchController?.removeListener(_onSearchChanged);

    _searchController?.dispose();

    _searchFocusNode?.removeListener(_searchFocusListener);

    _searchFocusNode?.dispose();

    _searchController = null;

    _searchFocusNode = null;

    super.onClose();
  }
}
