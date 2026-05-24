import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryController extends GetxController {
  // connect ke supabase
  final supabase = Supabase.instance.client;

  // riwayat user yang lagi login
  final RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void goBack() {
    // balik ke halaman sebelumnya, fallback ke home kalau stack kosong
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed('/home', arguments: {'initialIndex': 4});
    }
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;

      // ambil user login biar riwayat tiap akun beda
      final user = supabase.auth.currentUser;

      if (user == null) {
        history.clear();
        return;
      }

      final data = await supabase
          .from('history')
          .select('viewed_at, recipes(*, categories(name))')
          .eq('user_id', user.id)
          .order('viewed_at', ascending: false);

      history.assignAll(
        data.map<Map<String, dynamic>>((item) {
          final recipe = Map<String, dynamic>.from(item['recipes'] ?? {});
          final mappedRecipe = _recipeToHistoryMap(recipe);

          mappedRecipe['timestamp'] = item['viewed_at'];

          return mappedRecipe;
        }).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearHistory() async {
    try {
      // hapus semua riwayat punya user login
      final user = supabase.auth.currentUser;

      if (user == null) {
        history.clear();
        return;
      }

      await supabase.from('history').delete().eq('user_id', user.id);

      history.clear();

      Get.snackbar(
        '',
        'Riwayat berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF8B4513),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        messageText: const Text(
          'Riwayat berhasil dihapus',
          style: TextStyle(color: Colors.white),
        ),
        titleText: const SizedBox.shrink(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showClearHistoryDialog() {
    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.78,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEED6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hapus semua riwayat?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A4A2E),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Riwayat yang sudah dihapus tidak\nbisa dikembalikan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF7A4A2E).withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          clearHistory();
                        },
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8A77B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6BE97),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A4A2E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTimestamp(dynamic timestamp) {
    final date = _parseDate(timestamp);

    if (date == null) {
      return '-';
    }

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  DateTime? _parseDate(dynamic timestamp) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    if (timestamp is String) {
      final millis = int.tryParse(timestamp);

      if (millis != null) {
        return DateTime.fromMillisecondsSinceEpoch(millis);
      }

      return DateTime.tryParse(timestamp)?.toLocal();
    }

    return null;
  }
}

// ============================================
// HELPER FUNCTION - Add to History
// ============================================
Map<String, dynamic> _recipeToHistoryMap(Map<String, dynamic> recipe) {
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

Future<void> addToHistory(Map<String, dynamic> recipe) async {
  final supabase = Supabase.instance.client;

  // ambil user login biar riwayat masuk ke akun yang bener
  final user = supabase.auth.currentUser;
  final recipeId = recipe['id']?.toString() ?? '';

  if (user == null || recipeId.isEmpty) {
    return;
  }

  final existing = await supabase
      .from('history')
      .select('id')
      .eq('user_id', user.id)
      .eq('recipe_id', recipeId)
      .maybeSingle();

  if (existing != null) {
    // kalau udah pernah dibuka, update waktunya aja
    await supabase
        .from('history')
        .update({'viewed_at': DateTime.now().toIso8601String()})
        .eq('user_id', user.id)
        .eq('recipe_id', recipeId);
  } else {
    // kalau belum ada, masukin history baru
    await supabase.from('history').insert({
      'user_id': user.id,
      'recipe_id': recipeId,
    });
  }

  if (Get.isRegistered<HistoryController>()) {
    Get.find<HistoryController>().loadHistory();
  }
}
