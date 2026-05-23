import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../recipe_detail/views/recipe_detail_view.dart';
import '../../recipe_detail/controllers/recipe_detail_controller.dart';

import '../controllers/category_controller.dart';

class CategoryPage extends StatefulWidget {
  final String? selectedCategory;

  const CategoryPage({super.key, this.selectedCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final controller = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();

    // update category sekali aja
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedCategory != null) {
        controller.setCategory(widget.selectedCategory!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),

      body: Obx(() {
        // shimmer loading
        if (controller.isLoading.value) {
          return _buildSkeleton();
        }

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // header category
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,

                      size: 32,

                      color: Color(0xFF8B4513),
                    ),

                    onPressed: controller.prevCategory,
                  ),

                  IntrinsicWidth(
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.currentCategory,

                            style: const TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,

                              color: Color(0xFF8B4513),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(height: 2, color: const Color(0xFF8B4513)),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right,

                      size: 32,

                      color: Color(0xFF8B4513),
                    ),

                    onPressed: controller.nextCategory,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // list recipe
              Expanded(
                child: Obx(() {
                  final recipes = controller.currentRecipes;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    itemCount: recipes.length,

                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      final isFavorite = controller.isFavorite(recipe.title);

                      return _RecipeCard(
                        title: recipe.title,

                        location: recipe.location,

                        time: recipe.cookingTime.toString(),

                        imagePath: recipe.imageUrl,

                        isFavorite: isFavorite,

                        onToggleFavorite: () {
                          controller.toggleFavoriteRecipe(recipe);
                        },

                        onShare: () {
                          controller.shareRecipe(recipe);
                        },

                        onTap: () {
                          Get.to(
                            () => RecipeDetailView(),

                            arguments: recipe,

                            binding: BindingsBuilder(() {
                              Get.lazyPut<RecipeDetailController>(
                                () => RecipeDetailController(),
                              );
                            }),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  // skeleton loading
  Widget _buildSkeleton() {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,

            highlightColor: Colors.grey.shade100,

            child: Column(
              children: [
                const SizedBox(height: 20),

                Container(width: 150, height: 24, color: Colors.white),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView.builder(
                    itemCount: 2,

                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),

                        height: 220,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(24),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final String title;

  final String location;

  final String time;

  final String imagePath;

  final bool isFavorite;

  final VoidCallback onToggleFavorite;

  final VoidCallback onShare;

  final VoidCallback onTap;

  const _RecipeCard({
    required this.title,

    required this.location,

    required this.time,

    required this.imagePath,

    required this.isFavorite,

    required this.onToggleFavorite,

    required this.onShare,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 20),

        height: 220,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          image: DecorationImage(
            image: CachedNetworkImageProvider(imagePath),

            fit: BoxFit.cover,
          ),
        ),

        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: LinearGradient(
                  begin: Alignment.topCenter,

                  end: Alignment.bottomCenter,

                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,

              child: Row(
                children: [
                  _circleIcon(Icons.share, onShare),

                  const SizedBox(width: 10),

                  _circleIcon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,

                    onToggleFavorite,

                    color: isFavorite ? Colors.amber : Colors.black,
                  ),
                ],
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 20,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 26,

                      fontWeight: FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,

                        size: 14,

                        color: Colors.white,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        location,

                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.access_time,

                        size: 14,

                        color: Colors.white,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '$time menit',

                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(
    IconData icon,

    VoidCallback onTap, {

    Color color = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(8),

        decoration: const BoxDecoration(
          color: Colors.white,

          shape: BoxShape.circle,
        ),

        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
