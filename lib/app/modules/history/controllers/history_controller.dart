import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryController extends GetxController {
  final RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('recipe_history');

    if (historyJson != null) {
      final List<dynamic> decodedList = json.decode(historyJson);
      final List<Map<String, dynamic>> parsed = decodedList
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();

      // Sort by timestamp (newest first)
      parsed.sort((a, b) {
        int timeA = int.tryParse(a['timestamp'].toString()) ?? 0;
        int timeB = int.tryParse(b['timestamp'].toString()) ?? 0;
        return timeB.compareTo(timeA);
      });

      history.assignAll(parsed);
    }

    isLoading.value = false;
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recipe_history');
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
    int parsedTimestamp;

    if (timestamp is int) {
      parsedTimestamp = timestamp;
    } else if (timestamp is String) {
      parsedTimestamp = int.tryParse(timestamp) ?? 0;
    } else {
      parsedTimestamp = 0;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(parsedTimestamp);
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
}

// ============================================
// HELPER FUNCTION - Add to History
// ============================================
Future<void> addToHistory(Map<String, dynamic> recipe) async {
  final prefs = await SharedPreferences.getInstance();
  final String? historyJson = prefs.getString('recipe_history');

  List<dynamic> history = [];
  if (historyJson != null) {
    history = json.decode(historyJson);
  }

  // Remove if already exists (to avoid duplicates)
  history.removeWhere((item) => item['id'] == recipe['id']);

  // Add timestamp
  recipe['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

  // Add to beginning of list
  history.insert(0, recipe);

  // Keep only last 50 items
  if (history.length > 50) {
    history = history.sublist(0, 50);
  }

  await prefs.setString('recipe_history', json.encode(history));
}