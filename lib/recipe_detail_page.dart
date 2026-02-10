import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeName;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;


  const RecipeDetailPage({
    super.key,
    required this.recipeName,
    required this.imagePath,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  bool get isPempek => recipeName == 'Pempek';
  bool get isRawon => recipeName == 'Rawon';
  bool get isKlepon => recipeName == 'Klepon';
  bool get isLontongOpor => recipeName == 'Lontong Opor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // HEADER IMAGE
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF8B4513),
                  child: const Center(
                    child: Icon(Icons.image, size: 80, color: Colors.white),
                  ),
                );
              },
            ),
          ),

          // TOP BUTTONS
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    _circleButton(icon: Icons.share),
                    const SizedBox(width: 12),
                    _circleButton(
                     icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    onTap: onToggleFavorite,
              ),

                  ],
                ),
              ],
            ),
          ),

          // BOTTOM SHEET
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
                        // DRAG HANDLE
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
                          recipeName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B3E26),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ================= PEMPEK =================
                        if (isPempek) ...[
                          Text(
                            'Olahan khas Palembang berbahan dasar ikan dan sagu, disajikan dengan kuah cuko yang asam pedas.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: const Color(0xFF6B3E26).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoCard(Icons.access_time, '30', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Sumatra', 'Selatan'),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '500 g', ' ikan tenggiri halus'),
                          _buildIngredientItem('2. ', '250 g', ' tepung sagu'),
                          _buildIngredientItem('3. ', '200 ml', ' air es'),
                          _buildIngredientItem('4. ', '2 siung', ' bawang putih, haluskan'),
                          _buildIngredientItem('5. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep('1. Buat adonan',
                              'Campur ikan, bawang putih, garam, dan air hingga rata.'),
                          _buildStep('2. Tambahkan sagu',
                              'Masukkan sagu sedikit demi sedikit hingga adonan kalis.'),
                          _buildStep('3. Rebus',
                              'Bentuk pempek, rebus hingga mengapung dan matang.'),
                          _buildStep('4. Sajikan',
                              'Sajikan pempek dengan kuah cuko.'),
                        ]

                        // ================= RAWON =================
                        else if (isRawon) ...[
                          Text(
                            'Sup daging khas Jawa Timur berkuah hitam dari kluwek dengan cita rasa gurih dan khas.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: const Color(0xFF6B3E26).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoCard(Icons.access_time, '60', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Jawa', 'Timur'),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '500 g', ' daging sapi'),
                          _buildIngredientItem('2. ', '2 liter', ' air'),
                          _buildIngredientItem('3. ', '3 buah', ' kluwek'),
                          _buildIngredientItem('4. ', '2 batang', ' serai, memarkan'),
                          _buildIngredientItem('5. ', '3 lembar', ' daun jeruk'),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep('1. Rebus daging',
                              'Rebus daging sapi hingga empuk, angkat dan potong-potong.'),
                          _buildStep('2. Tumis bumbu',
                              'Tumis bumbu halus dan kluwek hingga harum.'),
                          _buildStep('3. Masak kuah',
                              'Masukkan bumbu ke air rebusan daging, tambahkan rempah.'),
                          _buildStep('4. Sajikan',
                              'Rawon siap disajikan dengan nasi dan pelengkap.'),
                        ]

                        // ================= KLEPON =================
                        else if (isKlepon) ...[
                          Text(
                            'Jajanan tradisional Jawa berbahan tepung ketan dengan isian gula merah cair dan balutan kelapa parut.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: const Color(0xFF6B3E26).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoCard(Icons.access_time, '25', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Jawa', 'Tengah'),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '200 g', ' tepung ketan'),
                          _buildIngredientItem('2. ', '100 ml', ' air hangat'),
                          _buildIngredientItem('3. ', 'Pasta pandan', ' secukupnya'),
                          _buildIngredientItem('4. ', '100 g', ' gula merah, serut'),
                          _buildIngredientItem('5. ', '100 g', ' kelapa parut kukus'),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep('1. Buat adonan',
                              'Campur tepung ketan, air, dan pasta pandan hingga kalis.'),
                          _buildStep('2. Isi gula merah',
                              'Ambil adonan, pipihkan dan isi gula merah, lalu bulatkan.'),
                          _buildStep('3. Rebus',
                              'Rebus klepon hingga mengapung, angkat dan tiriskan.'),
                          _buildStep('4. Sajikan',
                              'Gulingkan klepon di kelapa parut dan sajikan.'),
                        ]

                        // ================= LONTONG OPOR =================
                        else if (isLontongOpor) ...[
                          Text(
                            'Hidangan khas Lebaran berupa lontong dengan kuah opor ayam yang gurih dan kaya rempah.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: const Color(0xFF6B3E26).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoCard(Icons.access_time, '50', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Jawa', 'Tengah'),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '1 ekor', ' ayam, potong'),
                          _buildIngredientItem('2. ', '1 liter', ' santan'),
                          _buildIngredientItem('3. ', '2 batang', ' serai'),
                          _buildIngredientItem('4. ', '3 lembar', ' daun jeruk'),
                          _buildIngredientItem('5. ', 'Lontong', ' secukupnya'),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep('1. Tumis bumbu',
                              'Tumis bumbu halus hingga harum, masukkan serai dan daun jeruk.'),
                          _buildStep('2. Masak ayam',
                              'Masukkan ayam, aduk hingga berubah warna.'),
                          _buildStep('3. Tuang santan',
                              'Masukkan santan, masak dengan api kecil hingga matang.'),
                          _buildStep('4. Sajikan',
                              'Sajikan opor ayam bersama lontong dan pelengkap.'),
                        ]

                        // ================= RENDANG (ASLI) =================
                        else ...[
                          Text(
                            'Olahan daging sapi dimasak lama dengan santan dan rempah, berwarna cokelat pekat, gurih pedas, dan tahan lama.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: const Color(0xFF6B3E26).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoCard(Icons.access_time, '180', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Sumatra', 'Barat'),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '1 kg', ' daging sapi'),
                          _buildIngredientItem('2. ', '1 liter', ' santan kental dari 3 butir kelapa tua'),
                          _buildIngredientItem('3. ', '500 ml', ' santan encer'),
                          _buildIngredientItem('4. ', '2 lembar', ' daun kunyit, simpulkan'),
                          _buildIngredientItem('5. ', '5 lembar', ' daun jeruk purut'),
                          _buildIngredientItem('6. ', '2 batang', ' serai, memarkan'),
                          _buildIngredientItem('7. ', '3 cm', ' lengkuas, memarkan'),
                          _buildIngredientItem('8. ', 'Garam', ' secukupnya'),
                          _buildIngredientItem('9. ', 'Gula', ' merah secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Bumbu halus :'),
                          _buildIngredientItem('1. ', '15 butir', ' bawang merah'),
                          _buildIngredientItem('2. ', '8 siung', ' bawang putih'),
                          _buildIngredientItem('3. ', '10 butir', ' kemiri, sangrai'),
                          _buildIngredientItem('4. ', '5 cm', ' jahe'),
                          _buildIngredientItem('5. ', '3 cm', ' kunyit'),
                          _buildIngredientItem('6. ', '2 sdm', ' ketumbar'),
                          _buildIngredientItem('7. ', '1 sdt', ' jintan'),
                          _buildIngredientItem('8. ', '10 buah', ' cabai merah keriting'),
                          const SizedBox(height: 32),
                          _sectionTitle('Cara membuat :'),
                          _buildStep(
                            '1. Tumis bumbu',
                            'Panaskan sedikit minyak, tumis bumbu halus bersama serai, lengkuas, daun kunyit, dan daun jeruk hingga harum dan matang.',
                          ),
                          _buildStep(
                            '2. Masukkan daging',
                            'Masukkan potongan daging sapi, aduk rata hingga daging berubah warna dan tercampur dengan bumbu.',
                          ),
                          _buildStep(
                            '3. Tuang santan encer',
                            'Masukkan santan encer. Masak dengan api sedang sambil sesekali diaduk agar santan tidak pecah.',
                          ),
                          _buildStep(
                            '4. Masak hingga setengah meresap (±60 menit)',
                            'Biarkan bumbu meresap ke dalam daging. Aduk perlahan.',
                          ),
                          _buildStep(
                            '5. Tambahkan santan kental',
                            'Setelah kuah agak menyusut, masukkan santan kental. Tambahkan garam dan gula merah. Masak dengan api kecil.',
                          ),
                          _buildStep(
                            '6. Masak lama (±120 menit)',
                            'Biarkan rendang dimasak perlahan hingga santan mengering, bumbu menghitam, dan minyak keluar. Aduk sesekali supaya tidak gosong.',
                          ),
                          _buildStep(
                            '7. Sajikan',
                            'Setelah bumbu benar-benar kering dan daging empuk, rendang siap dihidangkan.',
                          ),
                        ],

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

  // ===== COMPONENTS =====

   Widget _circleButton({required IconData icon, VoidCallback? onTap}) {
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
        color: icon == Icons.bookmark
            ? const Color(0xFFFFC107)
            : Colors.black,
      ),
    ),
  );
}


  Widget _buildInfoCard(IconData icon, String value, String label) {
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B3E26),
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

  Widget _sectionTitle(String text) {
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

  Widget _buildIngredientItem(String number, String amount, String ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF6B3E26)),
          children: [
            TextSpan(text: number, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ingredient),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF6B3E26)),
          children: [
            TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: desc),
          ],
        ),
      ),
    );
  }
}
