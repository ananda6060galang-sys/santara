import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // pencarian
  final List<String> _searchSuggestions = [
    'Resep Rendang Padang',
    'Sambal 20 menit',
    'Jajanan khas Jawa Barat',
    'Pempek Palembang',
    'Rawon Surabaya',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchActive = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void activateSearch() {
    setState(() {
      _isSearchActive = true;
    });
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tutup dropdown ketika tap di luar
        if (_isSearchActive) {
          setState(() {
            _isSearchActive = false;
          });
          _searchFocusNode.unfocus();
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

                  // Logo & Title dengan Image
                  Row(
                    children: [
                      // Logo 
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
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Subtitle
                  const Text(
                    'Cita Rasa Nusantara Menanti !',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar dengan Dropdown
                  Stack(
                    children: [
                      Column(
                        children: [
                          // Search Bar
                          GestureDetector(
                            onTap: activateSearch,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEADBC8),
                                borderRadius: _isSearchActive
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      )
                                    : BorderRadius.circular(15),
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
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

                          // Dropdown Suggestions
                          if (_isSearchActive)
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFEADCC7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: _searchSuggestions.map((suggestion) {
                                  return InkWell(
                                    onTap: () {
                                      _searchController.text = suggestion;
                                      setState(() {
                                        _isSearchActive = false;
                                      });
                                      _searchFocusNode.unfocus();
                                      // Handle search action here
                                      print('Selected: $suggestion');
                                    },
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
                  ),
                  const SizedBox(height: 25),

                  // Resep Unggulan Nusantara (5 items horizontal scroll)
                  const Text(
                    'Resep Unggulan Nusantara',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 5 Featured Recipe Cards (Horizontal Scroll)
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFeaturedCard(
                          'Rendang',
                          'Sumatera Barat',
                          '45 menit',
                          'Lauk',
                          'assets/makan.png',
                        ),
                        _buildFeaturedCard(
                          'Pempek',
                          'Sumatera Selatan',
                          '30 menit',
                          'Makanan berat',
                          'assets/makan2.png',
                        ),
                        _buildFeaturedCard(
                          'Rawon',
                          'Jawa Timur',
                          '60 menit',
                          'Makanan berat',
                          'assets/makan3.png',
                        ),
                        _buildFeaturedCard(
                          'Klepon',
                          'Jawa Tengah',
                          '25 menit',
                          'Jajanan',
                          'assets/makan4.png',
                        ),
                        _buildFeaturedCard(
                          'Lontong Opor',
                          'Jawa Tengah',
                          '50 menit',
                          'Makanan berat',
                          'assets/makan5.png',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Kategori Resep 
                  const Text(
                    'Kategori Resep',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 6 Category Cards 
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard(
                          'Makanan berat',
                          'assets/makan berat.png',
                        ),
                        _buildCategoryCard(
                          'Lauk',
                          'assets/lauk.png',
                        ),
                        _buildCategoryCard(
                          'Sambal',
                          'assets/sambal.png',
                        ),
                        _buildCategoryCard(
                          'Minuman',
                          'assets/minuman.png',
                        ),
                        _buildCategoryCard(
                          'Makanan ringan',
                          'assets/makananringan.png',
                        ),
                        _buildCategoryCard(
                          'Jajanan',
                          'assets/jajanan.png',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for navbar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Featured Card untuk Rekomendasi (5 items)
  Widget _buildFeaturedCard(
    String title,
    String location,
    String duration,
    String category,
    String imagePath,
  ) {
    return Container(
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
            // Background Image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF8B4513),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay
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
            // Top buttons
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
                          category,
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom info
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
                        location,
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
                        duration,
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
    );
  }

  // Category Card (6 items - HORIZONTAL SCROLL)
  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
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
            // Background Image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFD4A574),
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Title
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
    );
  }
}