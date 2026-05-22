import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteController extends GetxController {
  final RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');

    if (favoritesJson != null) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      favorites.assignAll(decodedList.cast<Map<String, dynamic>>());
    }

    isLoading.value = false;
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = json.encode(favorites.toList());
    await prefs.setString('favorites', favoritesJson);
  }

  void removeFavorite(int index) {
    final recipeName = favorites[index]['title'];
    favorites.removeAt(index);
    saveFavorites();

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
// HELPER FUNCTIONS untuk Home Page
// ============================================

Future<bool> isRecipeFavorited(String recipeId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? favoritesJson = prefs.getString('favorites');

  if (favoritesJson != null) {
    final List<dynamic> favorites = json.decode(favoritesJson);
    return favorites.any((recipe) => recipe['id'] == recipeId);
  }
  return false;
}

Future<bool> toggleFavorite(Map<String, dynamic> recipe) async {
  final prefs = await SharedPreferences.getInstance();
  final String? favoritesJson = prefs.getString('favorites');

  List<dynamic> favorites = [];
  if (favoritesJson != null) {
    favorites = json.decode(favoritesJson);
  }

  final index = favorites.indexWhere((r) => r['id'] == recipe['id']);

  if (index >= 0) {
    // Remove from favorites
    favorites.removeAt(index);
    await prefs.setString('favorites', json.encode(favorites));
    return false; // Not favorited anymore
  } else {
    // Add to favorites
    favorites.add(recipe);
    await prefs.setString('favorites', json.encode(favorites));
    return true; // Now favorited
  }
}