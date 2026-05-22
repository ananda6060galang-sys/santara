import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../models/recipe_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (controller.isSearchActive.value) {
            controller.deactivateSearch();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFDF8F3),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // LOGO & TITLE
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo_santara.png',
                          width: 45,
                          height: 45,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4A574),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Color(0xFF8B4513),
                                  size: 28,
                                ),
                              ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Santara',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // SUBTITLE
                    const Text(
                      'Cita Rasa Nusantara Menanti !',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SEARCH BAR
                    _buildSearchBar(),
                    const SizedBox(height: 25),

                    // RESEP UNGGULAN
                    const Text(
                      'Resep Unggulan Nusantara',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.featuredRecipes
                            .map((recipe) => _buildFeaturedCard(recipe))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // KATEGORI RESEP
                    const Text(
                      'Kategori Resep',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.categoryList
                            .map(
                              (cat) => _buildCategoryCard(
                                cat['title']!,
                                cat['imagePath']!,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== SEARCH BAR =====
  Widget _buildSearchBar() {
    return Stack(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: controller.activateSearch,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEADBC8),
                  borderRadius: controller.isSearchActive.value
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )
                      : BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Cari resep...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9C7A5A).withOpacity(0.5),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF6B3E26).withOpacity(0.7),
                    ),
                    suffixIcon: Icon(
                      Icons.mic,
                      color: const Color(0xFF6B3E26).withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isSearchActive.value)
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEADCC7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: controller.searchSuggestions.map((suggestion) {
                    return InkWell(
                      onTap: () => controller.selectSuggestion(suggestion),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFF8B4513).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: TextStyle(
                            color: const Color(0xFF8B4513).withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ===== FEATURED CARD =====
  Widget _buildFeaturedCard(RecipeModel recipe) {
    final title = recipe.title;
    return Obx(() {
      final isFavorite = controller.favoriteRecipes[title] ?? false;
      return GestureDetector(
        onTap: () => controller.goToRecipeDetail(recipe),
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // TOP ROW (category badge + share + bookmark)
                Positioned(
                  top: 15,
                  left: 15,
                  right: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              recipe.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // SHARE
                          GestureDetector(
                            onTap: () => controller.shareRecipe(recipe),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.share, size: 16),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // BOOKMARK
                          GestureDetector(
                            onTap: () =>
                                controller.toggleFavoriteRecipe(recipe),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 16,
                                color: isFavorite
                                    ? const Color(0xFFFFC107)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // BOTTOM INFO
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe.location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${recipe.cookingTime} menit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ===== CATEGORY CARD =====
  Widget _buildCategoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () => controller.goToCategory(title),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
