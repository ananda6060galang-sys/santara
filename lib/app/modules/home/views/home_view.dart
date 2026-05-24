import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/home_controller.dart';
import '../../../models/recipe_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildSkeleton();
      }

      return GestureDetector(
        onTap: () {
          if (controller.isSearchActive.value) {
            controller.deactivateSearch();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFDF8F3),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // semua konten yang kena padding horizontal 20
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // logo app
                        Row(
                          children: [
                            Image.asset(
                              'assets/logo_santara.png',
                              width: 45,
                              height: 45,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
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
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Santara',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // subtitle
                        const Text(
                          'Cita Rasa Nusantara Menanti !',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B4513),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // search bar
                        _buildSearchBar(),

                        if (controller.searchQuery.value.trim().isEmpty) ...[
                          const SizedBox(height: 25),

                          // title unggulan
                          const Text(
                            'Resep Unggulan Nusantara',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),

                          const SizedBox(height: 15),
                        ],
                      ],
                    ),
                  ),

                  if (controller.searchQuery.value.trim().isEmpty) ...[
                    // carousel full width, bebas dari padding
                    _buildFeaturedCarousel(),

                    // konten bawah carousel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),

                          // title category
                          const Text(
                            'Kategori Resep',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // category list
                          SizedBox(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: controller.categoryList.map((cat) {
                                return _buildCategoryCard(
                                  cat['name'],
                                  cat['image_url'],
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ] else
                    _buildSearchResultsSection(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // search bar
  Widget _buildSearchBar() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.diagonal3Values(
          controller.isSearchActive.value ? 1.01 : 1.0,
          controller.isSearchActive.value ? 1.01 : 1.0,
          1,
        ),
        transformAlignment: Alignment.center,
        child: Column(
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
                  boxShadow: controller.isSearchActive.value
                      ? [
                          BoxShadow(
                            color: const Color(0xFF8B4513).withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Cari resep...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9C7A5A).withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF6B3E26).withOpacity(0.7),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: controller.onMicTap,
                      child: Icon(
                        Icons.mic,
                        color: const Color(0xFF6B3E26).withOpacity(0.7),
                      ),
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
            if (controller.isSearchActive.value &&
                controller.searchQuery.value.trim().isEmpty)
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEADCC7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: _buildSearchDropdown(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchDropdown() {
    return Column(
      children: controller.searchSuggestions.map((suggestion) {
        return _buildSearchRow(
          title: suggestion,
          icon: Icons.search,
          onTap: () {
            controller.selectSuggestion(suggestion);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchRow({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      // biar rekomendasi kepilih duluan sebelum dropdown ketutup
      onPointerDown: (_) => onTap(),
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
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF8B4513).withOpacity(0.55),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF8B4513).withOpacity(0.7),
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF8B4513).withOpacity(0.45),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Hasil Pencarian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 15),
          if (controller.searchResults.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                'Resep tidak ditemukan',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF8B4513).withOpacity(0.6),
                ),
              ),
            )
          else
            ...controller.searchResults.map(_buildSearchResultCard),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(RecipeModel recipe) {
    return Obx(() {
      final isFavorite = controller.favoriteRecipes[recipe.id] ?? false;

      return GestureDetector(
        onTap: () {
          controller.selectSearchRecipe(recipe);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFFEADBC8),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
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
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.shareRecipe(recipe);
                            },
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
                          GestureDetector(
                            onTap: () {
                              controller.toggleFavoriteRecipe(recipe);
                            },
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
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 26,
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
                          Expanded(
                            child: Text(
                              recipe.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
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
        ),
      );
    });
  }

  // carousel full width
  Widget _buildFeaturedCarousel() {
    final RxInt currentIndex = 0.obs;

    return Obx(
      () => Column(
        children: [
          CarouselSlider.builder(
            itemCount: controller.featuredRecipes.length,
            itemBuilder: (_, index, __) =>
                _buildFeaturedCard(controller.featuredRecipes[index]),
            options: CarouselOptions(
              height: 280,
              viewportFraction: 0.85,
              enlargeCenterPage: true,
              enlargeFactor: 0.15,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              autoPlayCurve: Curves.easeInOutCubic,
              padEnds: true,
              onPageChanged: (i, _) => currentIndex.value = i,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.featuredRecipes.length, (i) {
              final isActive = i == currentIndex.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF8B4513)
                      : const Color(0xFF8B4513).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // card resep
  Widget _buildFeaturedCard(RecipeModel recipe) {
    return Obx(() {
      final isFavorite = controller.favoriteRecipes[recipe.id] ?? false;

      return GestureDetector(
        onTap: () {
          controller.goToRecipeDetail(recipe);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // image resep
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        color: const Color(0xFFEADBC8),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF8B4513),
                        ),
                      );
                    },
                  ),
                ),

                // overlay
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

                // category + tombol
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
                          GestureDetector(
                            onTap: () {
                              controller.shareRecipe(recipe);
                            },
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
                          GestureDetector(
                            onTap: () {
                              controller.toggleFavoriteRecipe(recipe);
                            },
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

                // info bawah
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
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
                            style: const TextStyle(color: Colors.white),
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
        ),
      );
    });
  }

  // card category
 Widget _buildCategoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        controller.goToCategory(title);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFEADBC8),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ),
              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(width: 120, height: 25, color: Colors.white),
                const SizedBox(height: 20),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(height: 25),
                Container(width: 180, height: 20, color: Colors.white),
                const SizedBox(height: 20),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
