import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteController extends GetxController {
  // connect ke supabase
  final supabase = Supabase.instance.client;

  // list favorit user yang lagi login
  final RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;

      // ambil user login biar favorit tiap akun beda
      final user = supabase.auth.currentUser;

      if (user == null) {
        favorites.clear();
        return;
      }

      final data = await supabase
          .from('favorites')
          .select('recipes(*, categories(name))')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      favorites.assignAll(
        data.map<Map<String, dynamic>>((item) {
          final recipe = Map<String, dynamic>.from(item['recipes'] ?? {});

          return _recipeToFavoriteMap(recipe);
        }).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(int index) async {
    final recipe = favorites[index];
    final recipeId = recipe['id']?.toString() ?? '';
    final recipeName = recipe['title']?.toString() ?? 'Resep';

    final result = await toggleFavorite(recipe);

    if (!result) {
      favorites.removeWhere((item) => item['id']?.toString() == recipeId);
    }

    Get.snackbar(
      '',
      '$recipeName dihapus dari koleksi',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF8B4513),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      messageText: Text(
        '$recipeName dihapus dari koleksi',
        style: const TextStyle(color: Colors.white),
      ),
      titleText: const SizedBox.shrink(),
    );
  }
}

// ============================================
// HELPER FUNCTIONS untuk Home, Category, Detail
// ============================================

Map<String, dynamic> _recipeToFavoriteMap(Map<String, dynamic> recipe) {
  return {
    'id': recipe['id'] ?? '',
    'title': recipe['title'] ?? 'Resep',
    'description': recipe['description'] ?? '',
    'imagePath': recipe['image_url'] ?? recipe['imagePath'] ?? '',
    'image_url': recipe['image_url'] ?? recipe['imagePath'] ?? '',
    'location': recipe['location'] ?? '',
    'duration': '${recipe['cooking_time'] ?? 0} menit',
    'cooking_time': recipe['cooking_time'] ?? 0,
    'ingredients': recipe['ingredients'] ?? '',
    'steps': recipe['steps'] ?? '',
    'servings': recipe['servings'] ?? 0,
    'difficulty': recipe['difficulty'] ?? '',
    'categories': recipe['categories'],
  };
}

Future<bool> isRecipeFavorited(String recipeId) async {
  final supabase = Supabase.instance.client;

  // ambil user login dulu
  final user = supabase.auth.currentUser;

  if (user == null || recipeId.isEmpty) {
    return false;
  }

  final data = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', user.id)
      .eq('recipe_id', recipeId)
      .maybeSingle();

  return data != null;
}

Future<bool> toggleFavorite(Map<String, dynamic> recipe) async {
  final supabase = Supabase.instance.client;

  // ambil user login biar masuk ke akun yang bener
  final user = supabase.auth.currentUser;
  final recipeId = recipe['id']?.toString() ?? '';

  if (user == null || recipeId.isEmpty) {
    Get.snackbar(
      'Info',
      'Login dulu buat simpan resep.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  final existing = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', user.id)
      .eq('recipe_id', recipeId)
      .maybeSingle();

  if (existing != null) {
    // kalau sudah ada, hapus dari favorit
    await supabase
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('recipe_id', recipeId);

    if (Get.isRegistered<FavoriteController>()) {
      Get.find<FavoriteController>().loadFavorites();
    }

    return false;
  }

  // kalau belum ada, masukin ke favorit
  await supabase.from('favorites').insert({
    'user_id': user.id,
    'recipe_id': recipeId,
  });

  if (Get.isRegistered<FavoriteController>()) {
    Get.find<FavoriteController>().loadFavorites();
  }

  return true;
}
