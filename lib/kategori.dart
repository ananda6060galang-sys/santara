import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'recipe_detail_page.dart';
import 'favorit.dart';

class CategoryPage extends StatefulWidget {
  final String? selectedCategory;

  const CategoryPage({
    super.key,
    this.selectedCategory,
  });


  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int currentCategoryIndex = 0;
  final Map<String, bool> _favoriteCache = {};

  final List<String> categories = [
    'Makanan berat',
    'Lauk',
    'Sambal',
    'Minuman',
    'Makanan ringan',
    'Jajanan',
  ];



  final Map<String, List<Map<String, String>>> recipesByCategory = {
    'Makanan berat': [
      {'title': 'Nasi Kuning', 'location': 'Jawa Timur', 'time': '60 menit', 'image': 'makan_berat.png'},
      {'title': 'Rawon', 'location': 'Jawa Timur', 'time': '45 menit', 'image': 'makan_berat2.png'},
      {'title': 'Lontong Opor', 'location': 'Jawa Tengah', 'time': '50 menit', 'image': 'makan_berat3.png'},
      {'title': 'Nasi Goreng', 'location': 'Jawa Barat', 'time': '30 menit', 'image': 'makan_berat4.png'},
      {'title': 'Soto Ayam', 'location': 'Jawa Tengah', 'time': '40 menit', 'image': 'makan_berat5.png'},
      {'title': 'Bakso', 'location': 'Jawa Timur', 'time': '35 menit', 'image': 'makan_berat6.png'},
    ],
    'Lauk': [
      {'title': 'Rendang', 'location': 'Sumatra Barat', 'time': '120 menit', 'image': 'lauk1.png'},
      {'title': 'Gulai Nangka', 'location': 'Sumatra Barat', 'time': '90 menit', 'image': 'lauk2.png'},
      {'title': 'Ampela Balado', 'location': 'Sumatra Barat', 'time': '60 menit', 'image': 'lauk3.png'},
      {'title': 'Cumi Sambal Ijo', 'location': 'Sulawesi Utara', 'time': '45 menit', 'image': 'lauk4.png'},
      {'title': 'Tempe Orek', 'location': 'Jawa Tengah', 'time': '30 menit', 'image': 'lauk5.png'},
      {'title': 'Udang Mentega', 'location': 'Jawa Timur', 'time': '50 menit', 'image': 'lauk6.png'},
    ],
    'Sambal': [
      {'title': 'Sambal Matah', 'location': 'Bali', 'time': '20 menit', 'image': 'sambal1.png'},
      {'title': 'Sambal Kencur', 'location': 'Jawa Timur', 'time': '10 menit', 'image': 'sambal2.png'},
      {'title': 'Sambal Pecel', 'location': 'Jawa Tengah', 'time': '20 menit', 'image': 'sambal3.png'},
      {'title': 'Sambal Bajak', 'location': 'Jawa Barat', 'time': '25 menit', 'image': 'sambal4.png'},
      {'title': 'Sambal Bawang', 'location': 'Jawa Timur', 'time': '10 menit', 'image': 'sambal5.png'},
      {'title': 'Sambal Tomat', 'location': 'Sumatra Barat', 'time': '18 menit', 'image': 'sambal6.png'},
    ],
    'Minuman': [
      {'title': 'Es Cendol', 'location': 'Jawa Barat', 'time': '10 menit', 'image': 'minum1.png'},
      {'title': 'Es Teler', 'location': 'Jakarta', 'time': '15 menit', 'image': 'minum2.png'},
      {'title': 'Wedang Uwuh', 'location': 'Yogyakarta', 'time': '20 menit', 'image': 'minum3.png'},
      {'title': 'Wedang Jahe', 'location': 'Jawa Tengah', 'time': '15 menit', 'image': 'minum4.png'},
      {'title': 'Es Pisang Ijo', 'location': 'Sulawesi Selatan', 'time': '25 menit', 'image': 'minum5.png'},
      {'title': 'Jamu Kunyit', 'location': 'Jawa Tengah', 'time': '30 menit', 'image': 'minum6.png'},
    ],
    'Makanan ringan': [
      {'title': 'Mendoan', 'location': 'Jawa Tengah', 'time': '20 menit', 'image': 'ringan1.png'},
      {'title': 'Pastel', 'location': 'Jawa Barat', 'time': '25 menit', 'image': 'ringan2.png'},
      {'title': 'Combro', 'location': 'Jawa Barat', 'time': '30 menit', 'image': 'ringan3.png'},
      {'title': 'Bakwan', 'location': 'Jawa Timur', 'time': '15 menit', 'image': 'ringan4.png'},
      {'title': 'Lumpia', 'location': 'Semarang', 'time': '20 menit', 'image': 'ringan5.png'},
    ],
    'Jajanan': [
      {'title': 'Gethuk', 'location': 'Jawa Tengah', 'time': '60 menit', 'image': 'jajanan1.png'},
      {'title': 'Cucur', 'location': 'Jawa Barat', 'time': '20 menit', 'image': 'jajanan2.png'},
      {'title': 'Lapis', 'location': 'Betawi', 'time': '30 menit', 'image': 'jajanan3.png'},
      {'title': 'Apem', 'location': 'Jawa Tengah', 'time': '25 menit', 'image': 'jajanan4.png'},
      {'title': 'Dadar Gulung', 'location': 'Jawa Barat', 'time': '20 menit', 'image': 'jajanan5.png'},
      {'title': 'Klepon', 'location': 'Jawa Tengah', 'time': '15 menit', 'image': 'jajanan6.png'},
    ],
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
void initState() {
  super.initState();

  if (widget.selectedCategory != null) {
  final index = categories.indexOf(widget.selectedCategory!);

    if (index != -1) {
      currentCategoryIndex = index;
    }
  }

  _loadFavorites();
}


  Future<void> _loadFavorites() async {
    // Pre-load favorite status untuk semua resep
    for (final categoryRecipes in recipesByCategory.values) {
      for (final recipe in categoryRecipes) {
        final isFav = await isRecipeFavorited(recipe['title']!);
        if (mounted) {
          setState(() {
            _favoriteCache[recipe['title']!] = isFav;
          });
        }
      }
    }
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

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final bool isFavorite = _favoriteCache[recipe['title']] ?? false;

                  return _RecipeCard(
                    title: recipe['title']!,
                    location: recipe['location']!,
                    time: recipe['time']!,
                    imagePath: recipe['image']!,
                    isFavorite: isFavorite,
                    onToggleFavorite: () async {
                      final recipeData = {
                        'id': recipe['title']!,
                        'title': recipe['title']!,
                        'imagePath': 'assets/${recipe['image']!}',
                        'location': recipe['location']!,
                        'duration': recipe['time']!,
                        'description': '',
                      };
                      
                      final result = await toggleFavorite(recipeData);
                      if (mounted) {
                        setState(() {
                          _favoriteCache[recipe['title']!] = result;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result
                                  ? '${recipe['title']} ditambahkan ke favorit'
                                  : '${recipe['title']} dihapus dari favorit',
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF8B4513),
                          ),
                        );
                      }
                    },
                    onShare: () {
                      final text = '''
🍽️ *${recipe['title']}*

📍 Lokasi: ${recipe['location']}
⏱️ Waktu: ${recipe['time']}

Bagikan resep nusantara favorit kamu! 🇮🇩
                      ''';
                      
                      Share.share(
                        text,
                        subject: 'Resep ${recipe['title']} - Santara',
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipeName: recipe['title']!,
                            imagePath: 'assets/${recipe['image']!}',
                            location: recipe['location'] ?? '',
                            duration: recipe['time'] ?? '',
                          ),
                        ),
                      );
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
            image: AssetImage('assets/$imagePath'),
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
                    color: isFavorite ? const Color(0xFFFFC107) : Colors.black,
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
