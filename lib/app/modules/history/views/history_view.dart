import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/recipe_model.dart';
import '../controllers/history_controller.dart';
import '../../recipe_detail/controllers/recipe_detail_controller.dart';
import '../../recipe_detail/views/recipe_detail_view.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF8F3),
        body: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF8B5A3C),
                        size: 22,
                      ),
                      onPressed: controller.goBack,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Riwayat',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5A3C),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    if (controller.history.isNotEmpty)
                      GestureDetector(
                        onTap: controller.showClearHistoryDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D5B7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: const Color(0xFF8B5A3C).withOpacity(0.8),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Hapus',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF8B5A3C).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // CONTENT
              Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFB8956A),
                        ),
                      )
                    : controller.history.isEmpty
                        ? _buildEmptyState()
                        : _buildHistoryList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D5B7).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.history,
              size: 60,
              color: const Color(0xFF8B5A3C).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada riwayat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5A3C),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Resep yang kamu lihat akan muncul di sini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF8B5A3C).withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HISTORY LIST
  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.history.length,
      itemBuilder: (context, index) {
        final item = controller.history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Get.to(
                () => const RecipeDetailView(),
                arguments: _mapToRecipe(item),
                binding: BindingsBuilder(() {
                  Get.lazyPut<RecipeDetailController>(
                    () => RecipeDetailController(),
                  );
                }),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // RECIPE IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildRecipeImage(item['imagePath'] ?? ''),
                  ),
                  const SizedBox(width: 14),

                  // RECIPE INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? 'Resep',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5A3C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (item['location'] != null &&
                            item['location'].toString().isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: const Color(0xFF8B5A3C).withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['location'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF8B5A3C).withOpacity(0.5),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: const Color(0xFF8B5A3C).withOpacity(0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.formatTimestamp(item['timestamp'] ?? 0),
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF8B5A3C).withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ARROW ICON
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: const Color(0xFF8B5A3C).withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imageFallback();
        },
      );
    }

    return Image.asset(
      imagePath.isEmpty ? 'assets/makan.png' : imagePath,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imageFallback();
      },
    );
  }

  Widget _imageFallback() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5B7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.restaurant,
        size: 32,
        color: Color(0xFF8B5A3C),
      ),
    );
  }

  RecipeModel _mapToRecipe(Map<String, dynamic> recipe) {
    final duration = recipe['duration']?.toString() ?? '0 menit';
    final rawCookingTime = recipe['cooking_time'];
    final cookingTime = rawCookingTime is int
        ? rawCookingTime
        : int.tryParse(duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    return RecipeModel(
      id: recipe['id'] ?? '',
      title: recipe['title'] ?? 'Resep',
      description: recipe['description'] ?? '',
      imageUrl: recipe['image_url'] ?? recipe['imagePath'] ?? '',
      location: recipe['location'] ?? '',
      cookingTime: cookingTime,
      category: recipe['categories']?['name'] ?? '',
      ingredients: recipe['ingredients'] ?? '',
      steps: recipe['steps'] ?? '',
      servings: recipe['servings'] ?? 0,
      difficulty: recipe['difficulty'] ?? '',
    );
  }
}
