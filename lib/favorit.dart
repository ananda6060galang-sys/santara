import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recipe_detail_page.dart';

class KoleksiPage extends StatefulWidget {
  const KoleksiPage({super.key});

  @override
  State<KoleksiPage> createState() => _KoleksiPageState();
}

class _KoleksiPageState extends State<KoleksiPage> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');
    
    setState(() {
      if (favoritesJson != null) {
        final List<dynamic> decodedList = json.decode(favoritesJson);
        _favorites = decodedList.cast<Map<String, dynamic>>();
      }
      _isLoading = false;
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = json.encode(_favorites);
    await prefs.setString('favorites', favoritesJson);
  }

  void _removeFavorite(int index) {
    final recipeName = _favorites[index]['title'];
    setState(() {
      _favorites.removeAt(index);
    });
    _saveFavorites();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$recipeName dihapus dari koleksi'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF8B4513),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDF8F3),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFB8956A),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: _favorites.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFB8956A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 60,
                  color: const Color(0xFFB8956A),
                ),
                Positioned(
                  bottom: 25,
                  right: 25,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Koleksi rasa belum terisi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Belum ada resep di koleksimu. Simpan\nresep yang kamu suka agar mudah\nditemukan kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF8B4513).withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // List of Favorites
  Widget _buildFavoritesList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text(
                'Koleksi',
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
 
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final recipe = _favorites[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                          recipeName: recipe['title'] ?? 'Resep',
                          imagePath: recipe['imagePath'] ?? 'assets/makan.png',
                          location: recipe['location'] ?? '',
                          duration: recipe['duration'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Row(
                  children: [
                    // Recipe Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.asset(
                        recipe['imagePath'] ?? 'assets/makan.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            color: const Color(0xFFD4A574),
                            child: const Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    // Recipe Info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title'] ?? 'Resep',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B4513),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (recipe['description'] != null && recipe['description'].toString().isNotEmpty)
                              Text(
                                recipe['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF8B4513).withOpacity(0.6),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: const Color(0xFF8B4513).withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    recipe['location'] ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: const Color(0xFF8B4513).withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: const Color(0xFF8B4513).withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe['duration'] ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: const Color(0xFF8B4513).withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bookmark Button
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () => _removeFavorite(index),
                        icon: const Icon(
                          Icons.bookmark,
                          color: Color(0xFFB8956A),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 80), 
      ],
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