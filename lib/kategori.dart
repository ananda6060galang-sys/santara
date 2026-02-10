import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int currentCategoryIndex = 0;

  final List<String> categories = [
    'Makanan berat',
    'Lauk',
    'Sambal',
    'Minuman',
    'Makanan ringan',
    'Jajanan',
  ];

  final Map<String, bool> _favoriteRecipes = {};

  final Map<String, List<Map<String, String>>> recipesByCategory = {
    'Makanan berat': [
      {'title': 'Nasi Kuning', 'location': 'Jawa Timur', 'time': '60 menit', 'image': 'assets/makanan_berat1.png'},
      {'title': 'Rawon', 'location': 'Jawa Timur', 'time': '45 menit', 'image': 'assets/makanan_berat2.png'},
      {'title': 'Rendang', 'location': 'Sumatra Barat', 'time': '180 menit', 'image': 'assets/makanan_berat3.png'},
      {'title': 'Lontong Opor', 'location': 'Jawa Tengah', 'time': '50 menit', 'image': 'assets/makanan_berat4.png'},
      {'title': 'Soto Ayam', 'location': 'Jawa Tengah', 'time': '40 menit', 'image': 'assets/makanan_berat5.png'},
      {'title': 'Gudeg', 'location': 'Yogyakarta', 'time': '90 menit', 'image': 'assets/makanan_berat6.png'},
    ],
    'Lauk': List.generate(6, (i) => {
      'title': 'Lauk ${i + 1}',
      'location': 'Indonesia',
      'time': '30 menit',
      'image': 'assets/lauk.png'
    }),
    'Sambal': List.generate(6, (i) => {
      'title': 'Sambal ${i + 1}',
      'location': 'Indonesia',
      'time': '15 menit',
      'image': 'assets/sambal.png'
    }),
    'Minuman': List.generate(6, (i) => {
      'title': 'Minuman ${i + 1}',
      'location': 'Indonesia',
      'time': '10 menit',
      'image': 'assets/minuman.png'
    }),
    'Makanan ringan': List.generate(6, (i) => {
      'title': 'Snack ${i + 1}',
      'location': 'Indonesia',
      'time': '20 menit',
      'image': 'assets/snack.png'
    }),
    'Jajanan': List.generate(6, (i) => {
      'title': 'Jajanan ${i + 1}',
      'location': 'Indonesia',
      'time': '25 menit',
      'image': 'assets/jajanan.png'
    }),
  };

  void nextCategory() {
    setState(() {
      currentCategoryIndex =
          (currentCategoryIndex + 1) % categories.length;
    });
  }

  void prevCategory() {
    setState(() {
      currentCategoryIndex =
          (currentCategoryIndex - 1 + categories.length) % categories.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentCategory = categories[currentCategoryIndex];
    final recipes = recipesByCategory[currentCategory]!;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ===== HEADER CATEGORY (GARIS AUTO SESUAI TEKS) =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 32, color: Color(0xFF8B4513)),
                  onPressed: prevCategory,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Text(
                        currentCategory,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 2,
                        color: const Color(0xFF8B4513),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 32, color: Color(0xFF8B4513)),
                  onPressed: nextCategory,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===== LIST RESEP (VERTICAL) =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final bool isFavorite = _favoriteRecipes[recipe['title']] ?? false;

                  return _RecipeCard(
                    title: recipe['title']!,
                    location: recipe['location']!,
                    time: recipe['time']!,
                    imagePath: recipe['image']!,
                    isFavorite: isFavorite,
                    onToggleFavorite: () {
                      setState(() {
                        _favoriteRecipes[recipe['title']!] = !isFavorite;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== CARD RESEP (DENGAN SHARE + BOOKMARK) =====
class _RecipeCard extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _RecipeCard({
    required this.title,
    required this.location,
    required this.time,
    required this.imagePath,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(imagePath),
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
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),

          // ICON SHARE & BOOKMARK (SAMA KAYA HOME)
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                _circleIcon(Icons.share, () {}),
                const SizedBox(width: 10),
                _circleIcon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  onToggleFavorite,
                  color: isFavorite ? const Color(0xFFFFC107) : Colors.black,
                ),
              ],
            ),
          ),

          // TEXT
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
                    const Icon(Icons.location_on, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap, {Color color = Colors.black}) {
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
