import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/recipe_detail_controller.dart';

class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          // =====================================================
          // HEADER IMAGE
          // =====================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,

            height: MediaQuery.of(context).size.height * 0.45,

            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),

              child: Image.network(
                controller.recipe.imageUrl,

                fit: BoxFit.cover,

                alignment: Alignment.center,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF8B4513),

                    child: const Center(
                      child: Icon(Icons.image, size: 80, color: Colors.white),
                    ),
                  );
                },

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: const Color(0xFF8B4513),

                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,

                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // =====================================================
          // TOP BUTTONS
          // =====================================================
          Positioned(
            top: 50,
            left: 20,
            right: 20,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                _circleButton(
                  icon: Icons.arrow_back_ios_new,

                  onTap: () => Get.back(),
                ),

                Row(
                  children: [
                    _circleButton(
                      icon: Icons.share,

                      onTap: controller.shareRecipe,
                    ),

                    const SizedBox(width: 12),

                    Obx(
                      () => _circleButton(
                        icon: controller.isFavorited.value
                            ? Icons.bookmark
                            : Icons.bookmark_border,

                        onTap: controller.toggleFavoriteStatus,

                        isBookmark: true,

                        isFavorited: controller.isFavorited.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =====================================================
          // DRAGGABLE SHEET
          // =====================================================
          DraggableScrollableSheet(
            initialChildSize: 0.65,

            minChildSize: 0.65,

            maxChildSize: 0.9,

            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5EBD9),

                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),

                child: SingleChildScrollView(
                  controller: scrollController,

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // HANDLE
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,

                            decoration: BoxDecoration(
                              color: const Color(0xFF8B6F47).withOpacity(0.35),

                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // TITLE
                        Text(
                          controller.recipe.title,

                          style: const TextStyle(
                            fontSize: 36,

                            fontWeight: FontWeight.bold,

                            color: Color(0xFF6B3E26),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // DESCRIPTION
                        _descriptionText(controller.recipe.description),

                        const SizedBox(height: 28),

                        // INFO CARDS
                        _infoCards(
                          controller.recipe.cookingTime.toString(),

                          controller.recipe.location,

                          controller.recipe.servings.toString(),

                          controller.recipe.difficulty,
                        ),

                        const SizedBox(height: 36),

                        // =====================================================
                        // INGREDIENTS
                        // =====================================================
                        _sectionTitle('Bahan - bahan :'),

                        ...controller.ingredientsList.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key + 1;

                          final item = entry.value;

                          return _buildIngredientItem('$index. ', '', item);
                        }),

                        const SizedBox(height: 28),

                        // =====================================================
                        // STEPS
                        // =====================================================
                        _sectionTitle('Cara membuat :'),

                        ...controller.stepsList.asMap().entries.map((entry) {
                          final index = entry.key + 1;

                          final step = entry.value;

                          return _buildStep('Langkah $index', step);
                        }),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String number, String amount, String ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 15,

            height: 1.6,

            color: Color(0xFF6B3E26),
          ),

          children: [
            TextSpan(
              text: number,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            TextSpan(
              text: amount,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            TextSpan(text: ingredient),
          ],
        ),
      ),
    );
  }
  // =====================================================
  // HELPERS
  // =====================================================

  Widget _descriptionText(String text) {
    return Text(
      text,

      style: TextStyle(
        fontSize: 15,

        height: 1.6,

        color: const Color(0xFF6B3E26).withOpacity(0.75),
      ),
    );
  }

  Widget _infoCards(
    String time,

    String locationLabel,

    String porsi,

    String level,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        _buildInfoCard(Icons.access_time, time, 'menit'),

        _buildInfoCard(Icons.location_on, locationLabel, ''),

        _buildInfoCard(Icons.people, porsi, 'porsi'),

        _buildInfoCard(Icons.layers, level, ''),
      ],
    );
  }

  static Widget _circleButton({
    required IconData icon,

    VoidCallback? onTap,

    bool isBookmark = false,

    bool isFavorited = false,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),

          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,

          size: 20,

          color: isBookmark && isFavorited
              ? const Color(0xFFFFC107)
              : Colors.black,
        ),
      ),
    );
  }

  static Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      width: 80,
      height: 132,

      decoration: BoxDecoration(
        color: const Color(0xFFD4B896),

        borderRadius: BorderRadius.circular(36),
      ),

      child: Column(
        children: [
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),

            decoration: const BoxDecoration(
              color: Color(0xFFF5EBD9),

              shape: BoxShape.circle,
            ),

            child: Icon(icon, size: 26, color: Color(0xFF6B3E26)),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),

            child: Text(
              value,

              textAlign: TextAlign.center,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 13,

                fontWeight: FontWeight.bold,

                color: Color(0xFF6B3E26),
              ),
            ),
          ),

          if (label.isNotEmpty)
            Text(
              label,

              style: TextStyle(
                fontSize: 12,

                color: const Color(0xFF6B3E26).withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 20,

          fontWeight: FontWeight.bold,

          color: Color(0xFF6B3E26),
        ),
      ),
    );
  }

  static Widget _buildStep(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 15,

            height: 1.6,

            color: Color(0xFF6B3E26),
          ),

          children: [
            TextSpan(
              text: '$title\n',

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            TextSpan(text: desc),
          ],
        ),
      ),
    );
  }
}
