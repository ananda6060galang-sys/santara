import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'favorit.dart';
import 'riwayatpage.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeName;
  final String imagePath;
  final String location;
  final String duration;

  const RecipeDetailPage({
    super.key,
    required this.recipeName,
    required this.imagePath,
    this.location = '',
    this.duration = '',
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isFavorited = false;

  bool get isPempek => widget.recipeName == 'Pempek';
  bool get isRawon => widget.recipeName == 'Rawon';
  bool get isKlepon => widget.recipeName == 'Klepon';
  bool get isLontongOpor => widget.recipeName == 'Lontong Opor';
  bool get isSambalMatah => widget.recipeName == 'Sambal Matah';
  bool get isNasiKuning => widget.recipeName == 'Nasi Kuning';
  bool get isEsCendol => widget.recipeName == 'Es Cendol';
  bool get isMendoan => widget.recipeName == 'Mendoan';
  bool get isGethuk => widget.recipeName == 'Gethuk';

  @override
void initState() {
  super.initState();
  print("INIT STATE JALAN");
  _checkFavoriteStatus();
  _saveToHistory();
}


  
 Future<void> _saveToHistory() async {
  final recipeData = {
    'id': widget.recipeName,
    'title': widget.recipeName,
    'imagePath': widget.imagePath,
    'location': widget.location,
    'duration': widget.duration,
  };

  print("SAVING HISTORY: ${widget.recipeName}");
  await addToHistory(recipeData);
}


  // CEK STATUS BOOKMARK
  Future<void> _checkFavoriteStatus() async {
    final favorited = await isRecipeFavorited(widget.recipeName);
    setState(() {
      _isFavorited = favorited;
    });
  }

  // TOGGLE BOOKMARK
  Future<void> _toggleFavorite() async {
    final recipeData = {
      'id': widget.recipeName,
      'title': widget.recipeName,
      'imagePath': widget.imagePath,
      'location': widget.location,
      'duration': widget.duration,
      'description': _getDescription(),
    };

    final nowFavorited = await toggleFavorite(recipeData);
    setState(() {
      _isFavorited = nowFavorited;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nowFavorited
                ? '${widget.recipeName} ditambahkan ke koleksi'
                : '${widget.recipeName} dihapus dari koleksi',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF8B4513),
        ),
      );
    }
  }

  // FUNGSI SHARE
  void _shareRecipe() {
    final text =
        '''
🍽️ *${widget.recipeName}*

${_getDescription()}

📍 Lokasi: ${widget.location}
⏱️ Waktu: ${widget.duration}

Bagikan resep nusantara favorit kamu! 🇮🇩
    ''';

    Share.share(text, subject: 'Resep ${widget.recipeName} - Santara');
  }

  // GET DESCRIPTION
  String _getDescription() {
    if (isPempek) {
      return 'Olahan khas Palembang berbahan dasar ikan dan sagu, disajikan dengan kuah cuko yang asam pedas.';
    } else if (isRawon) {
      return 'Sup daging khas Jawa Timur berkuah hitam dari kluwek dengan cita rasa gurih dan khas.';
    } else if (isKlepon) {
      return 'Jajanan tradisional Jawa berbahan tepung ketan dengan isian gula merah cair dan balutan kelapa parut.';
    } else if (isLontongOpor) {
      return 'Hidangan khas Lebaran berupa lontong dengan kuah opor ayam yang gurih dan kaya rempah.';
    } else if (isSambalMatah) {
      return 'Sambal segar dari bawang merah, cabai rawit, serai, dan minyak kelapa, pedas aromatik tanpa dimasak.';
    } else if (isNasiKuning) {
      return 'Nasi gurih berwarna kuning dari kunyit dan santan, dimasak hingga harum dan biasa disajikan dengan berbagai lauk pendamping.';
    } else if (isEsCendol) {
      return 'Minuman segar dari tepung beras hijau, santan, dan gula merah cair, cocok diminum saat panas terik.';
    } else if (isMendoan) {
      return 'Tempe tipis berbalut adonan tepung berbumbu lalu digoreng setengah matang, gurih renyah lembut.';
    } else if (isGethuk) {
      return 'Jajanan manis dari singkong yang ditumbuk, dicampur gula dan parutan kelapa, lembut dan legit.';
    } else {
      return 'Olahan daging sapi dimasak lama dengan santan dan rempah, berwarna cokelat pekat, gurih pedas, dan tahan lama.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // HEADER IMAGE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              child: Image.asset(
                widget.imagePath,
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
              ),
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
                    _circleButton(icon: Icons.share, onTap: _shareRecipe),
                    const SizedBox(width: 12),
                    _circleButton(
                      icon: _isFavorited
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      onTap: _toggleFavorite,
                      isBookmark: true,
                      isFavorited: _isFavorited,
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
                          widget.recipeName,
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Sumatra',
                                'Selatan',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem(
                            '1. ',
                            '500 g',
                            ' ikan tenggiri halus',
                          ),
                          _buildIngredientItem('2. ', '250 g', ' tepung sagu'),
                          _buildIngredientItem('3. ', '200 ml', ' air es'),
                          _buildIngredientItem(
                            '4. ',
                            '2 siung',
                            ' bawang putih, haluskan',
                          ),
                          _buildIngredientItem('5. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep(
                            '1. Buat adonan',
                            'Campur ikan, bawang putih, garam, dan air hingga rata.',
                          ),
                          _buildStep(
                            '2. Tambahkan sagu',
                            'Masukkan sagu sedikit demi sedikit hingga adonan kalis.',
                          ),
                          _buildStep(
                            '3. Rebus',
                            'Bentuk pempek, rebus hingga mengapung dan matang.',
                          ),
                          _buildStep(
                            '4. Sajikan',
                            'Sajikan pempek dengan kuah cuko.',
                          ),
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Timur',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '500 g', ' daging sapi'),
                          _buildIngredientItem('2. ', '2 liter', ' air'),
                          _buildIngredientItem('3. ', '3 buah', ' kluwek'),
                          _buildIngredientItem(
                            '4. ',
                            '2 batang',
                            ' serai, memarkan',
                          ),
                          _buildIngredientItem(
                            '5. ',
                            '3 lembar',
                            ' daun jeruk',
                          ),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep(
                            '1. Rebus daging',
                            'Rebus daging sapi hingga empuk, angkat dan potong-potong.',
                          ),
                          _buildStep(
                            '2. Tumis bumbu',
                            'Tumis bumbu halus dan kluwek hingga harum.',
                          ),
                          _buildStep(
                            '3. Masak kuah',
                            'Masukkan bumbu ke air rebusan daging, tambahkan rempah.',
                          ),
                          _buildStep(
                            '4. Sajikan',
                            'Rawon siap disajikan dengan nasi dan pelengkap.',
                          ),
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Tengah',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '200 g', ' tepung ketan'),
                          _buildIngredientItem('2. ', '100 ml', ' air hangat'),
                          _buildIngredientItem(
                            '3. ',
                            'Pasta pandan',
                            ' secukupnya',
                          ),
                          _buildIngredientItem(
                            '4. ',
                            '100 g',
                            ' gula merah, serut',
                          ),
                          _buildIngredientItem(
                            '5. ',
                            '100 g',
                            ' kelapa parut kukus',
                          ),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep(
                            '1. Buat adonan',
                            'Campur tepung ketan, air, dan pasta pandan hingga kalis.',
                          ),
                          _buildStep(
                            '2. Isi gula merah',
                            'Ambil adonan, pipihkan dan isi gula merah, lalu bulatkan.',
                          ),
                          _buildStep(
                            '3. Rebus',
                            'Rebus klepon hingga mengapung, angkat dan tiriskan.',
                          ),
                          _buildStep(
                            '4. Sajikan',
                            'Gulingkan klepon di kelapa parut dan sajikan.',
                          ),
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Tengah',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem(
                            '1. ',
                            '1 ekor',
                            ' ayam, potong',
                          ),
                          _buildIngredientItem('2. ', '1 liter', ' santan'),
                          _buildIngredientItem('3. ', '2 batang', ' serai'),
                          _buildIngredientItem(
                            '4. ',
                            '3 lembar',
                            ' daun jeruk',
                          ),
                          _buildIngredientItem('5. ', 'Lontong', ' secukupnya'),
                          _buildIngredientItem('6. ', 'Garam', ' secukupnya'),
                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),
                          _buildStep(
                            '1. Tumis bumbu',
                            'Tumis bumbu halus hingga harum, masukkan serai dan daun jeruk.',
                          ),
                          _buildStep(
                            '2. Masak ayam',
                            'Masukkan ayam, aduk hingga berubah warna.',
                          ),
                          _buildStep(
                            '3. Tuang santan',
                            'Masukkan santan, masak dengan api kecil hingga matang.',
                          ),
                          _buildStep(
                            '4. Sajikan',
                            'Sajikan opor ayam bersama lontong dan pelengkap.',
                          ),
                        ]
                        // ================= SAMBAL MATAH =================
                        else if (isSambalMatah) ...[
                          Text(
                            'Sambal segar dari bawang merah, cabai rawit, serai, dan minyak kelapa, pedas aromatik tanpa dimasak.',
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
                              _buildInfoCard(Icons.access_time, '20', 'menit'),
                              _buildInfoCard(Icons.location_on, 'Bali', ''),
                              _buildInfoCard(Icons.people, '2', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),

                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),

                          _buildIngredientItem(
                            '1. ',
                            '10 siung',
                            ' bawang merah, iris tipis',
                          ),
                          _buildIngredientItem(
                            '2. ',
                            '8 buah',
                            ' cabai rawit merah, iris tipis',
                          ),
                          _buildIngredientItem(
                            '3. ',
                            '5 buah',
                            ' cabai merah keriting, iris tipis',
                          ),
                          _buildIngredientItem(
                            '4. ',
                            '2 batang',
                            ' serai, ambil bagian putihnya, iris halus',
                          ),
                          _buildIngredientItem(
                            '5. ',
                            '5 lembar',
                            ' daun jeruk, buang tulang tengah, iris halus',
                          ),
                          _buildIngredientItem('6. ', '½ sdt', ' garam'),
                          _buildIngredientItem('7. ', '½ sdt', ' gula pasir'),
                          _buildIngredientItem(
                            '8. ',
                            '½ buah',
                            ' jeruk limo (opsional)',
                          ),
                          _buildIngredientItem(
                            '9. ',
                            '5 sdm',
                            ' minyak kelapa/minyak goreng, dipanaskan',
                          ),

                          const SizedBox(height: 28),
                          _sectionTitle('Cara membuat :'),

                          _buildStep(
                            '1. Siapkan bumbu',
                            'Campur bawang merah, cabai rawit, cabai keriting, serai, dan daun jeruk dalam wadah.',
                          ),

                          _buildStep(
                            '2. Beri bumbu dasar',
                            'Tambahkan garam, gula, dan perasan jeruk limo (jika digunakan). Aduk rata.',
                          ),

                          _buildStep(
                            '3. Tuang minyak panas',
                            'Panaskan minyak hingga benar-benar panas, lalu siram ke dalam campuran bumbu. Aduk rata.',
                          ),

                          _buildStep(
                            '4. Sajikan',
                            'Sambal matah siap disajikan sebagai pelengkap lauk goreng, ayam, atau ikan bakar.',
                          ),
                        ]
                        // ================= NASI KUNING =================
                        else if (isNasiKuning) ...[
                          Text(
                            'Nasi gurih berwarna kuning dari kunyit dan santan, dimasak hingga harum dan biasa disajikan dengan berbagai lauk pendamping.',
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Timur',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),

                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),

                          _buildIngredientItem('1. ', '1 kg', ' beras'),
                          _buildIngredientItem(
                            '2. ',
                            '2 bks',
                            ' santan instan 65 ml',
                          ),
                          _buildIngredientItem(
                            '3. ',
                            '2 lembar',
                            ' daun salam',
                          ),
                          _buildIngredientItem(
                            '4. ',
                            '2 lembar',
                            ' daun jeruk',
                          ),
                          _buildIngredientItem('5. ', '1 batang', ' serai'),
                          _buildIngredientItem('6. ', '1 sdm', ' garam'),
                          _buildIngredientItem('7. ', '1 bks', ' royco ayam'),

                          const SizedBox(height: 28),
                          _sectionTitle('Bumbu halus :'),

                          _buildIngredientItem(
                            '1. ',
                            '5 siung',
                            ' bawang merah',
                          ),
                          _buildIngredientItem(
                            '2. ',
                            '4 siung',
                            ' bawang putih',
                          ),
                          _buildIngredientItem(
                            '3. ',
                            '1 sdt',
                            ' ketumbar butiran',
                          ),
                          _buildIngredientItem('4. ', '1 butir', ' kemiri'),
                          _buildIngredientItem('5. ', '1 jempol', ' kunyit'),

                          const SizedBox(height: 32),
                          _sectionTitle('Cara membuat :'),

                          _buildStep(
                            '1. Tumis bumbu',
                            'Tumis bumbu halus bersama daun salam, daun jeruk, dan serai hingga matang dan harum.',
                          ),

                          _buildStep(
                            '2. Masak beras',
                            'Masukkan beras dan air sebanyak 1,5 ruas jari di atas permukaan beras. Tambahkan santan, garam, dan royco. Masak hingga air menyusut sambil diaduk agar tidak berkerak di bagian bawah.',
                          ),

                          _buildStep(
                            '3. Kukus',
                            'Panaskan kukusan, lalu masukkan beras yang sudah diaron. Kukus selama 45 menit sambil sesekali diaduk agar matang merata.',
                          ),

                          _buildStep(
                            '4. Sajikan',
                            'Nasi kuning siap dinikmati bersama lauk pendamping.',
                          ),
                        ]
                        // ================= ES CENDOL =================
                        else if (isEsCendol) ...[
                          Text(
                            'Minuman segar dari tepung beras hijau, santan, dan gula merah cair, cocok diminum saat panas terik.',
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
                              _buildInfoCard(Icons.access_time, '20', 'menit'),
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'barat',
                              ),
                              _buildInfoCard(Icons.people, '1', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),

                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),

                          _buildIngredientItem('1. ', '100 g', ' tepung beras'),
                          _buildIngredientItem('2. ', '50 g', ' tepung hunkwe'),
                          _buildIngredientItem('3. ', '700 ml', ' air'),
                          _buildIngredientItem('4. ', '1 sdt', ' pasta pandan'),
                          _buildIngredientItem('5. ', '½ sdt', ' garam'),
                          _buildIngredientItem('6. ', '500 g', ' es batu'),
                          _buildIngredientItem('7. ', '200 g', ' gula merah'),
                          _buildIngredientItem(
                            '8. ',
                            '200 ml',
                            ' santan kental',
                          ),
                          _buildIngredientItem(
                            '9. ',
                            '2 lembar',
                            ' daun pandan',
                          ),

                          const SizedBox(height: 32),
                          _sectionTitle('Cara membuat :'),

                          _buildStep(
                            '1. Masak adonan cendol',
                            'Campur tepung beras, tepung hunkwe, garam, pasta pandan, dan air. Masak sambil diaduk hingga mengental dan meletup.',
                          ),

                          _buildStep(
                            '2. Cetak cendol',
                            'Cetak adonan menggunakan saringan khusus cendol ke dalam wadah berisi air es hingga membentuk butiran cendol.',
                          ),

                          _buildStep(
                            '3. Buat gula merah',
                            'Rebus gula merah dengan sedikit air dan daun pandan hingga larut dan mengental, lalu saring.',
                          ),

                          _buildStep(
                            '4. Sajikan',
                            'Sajikan cendol dengan gula merah cair, santan kental, dan es batu.',
                          ),
                        ]
                        // ================= MENDOAN =================
                        else if (isMendoan) ...[
                          Text(
                            'Tempe tipis berbalut adonan tepung berbumbu lalu digoreng setengah matang, gurih renyah lembut.',
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
                              _buildInfoCard(Icons.access_time, '20', 'menit'),
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Tengah',
                              ),
                              _buildInfoCard(Icons.people, '5', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),

                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),

                          _buildIngredientItem(
                            '1. ',
                            '10 lembar',
                            ' tempe tipis',
                          ),
                          _buildIngredientItem(
                            '2. ',
                            '100 g',
                            ' tepung terigu',
                          ),
                          _buildIngredientItem('3. ', '20 g', ' tepung beras'),
                          _buildIngredientItem(
                            '4. ',
                            '2 siung',
                            ' bawang putih',
                          ),
                          _buildIngredientItem(
                            '5. ',
                            '3 batang',
                            ' daun bawang, iris tipis',
                          ),
                          _buildIngredientItem(
                            '6. ',
                            '½ sdt',
                            ' ketumbar bubuk',
                          ),
                          _buildIngredientItem('7. ', '½ sdt', ' garam'),
                          _buildIngredientItem('8. ', '200 ml', ' air'),
                          _buildIngredientItem(
                            '9. ',
                            'Minyak goreng',
                            ' secukupnya',
                          ),

                          const SizedBox(height: 32),
                          _sectionTitle('Cara membuat :'),

                          _buildStep(
                            '1. Buat adonan',
                            'Haluskan bawang putih, lalu campur dengan tepung terigu, tepung beras, ketumbar, garam, daun bawang, dan air.',
                          ),

                          _buildStep(
                            '2. Aduk rata',
                            'Aduk hingga menjadi adonan agak encer dan tercampur merata.',
                          ),

                          _buildStep(
                            '3. Celupkan tempe',
                            'Masukkan tempe ke dalam adonan hingga seluruh permukaannya terlapisi.',
                          ),

                          _buildStep(
                            '4. Goreng setengah matang',
                            'Panaskan minyak, goreng tempe sebentar hingga matang tetapi tidak kering (mendoan).',
                          ),

                          _buildStep(
                            '5. Sajikan',
                            'Angkat dan tiriskan, sajikan hangat bersama cabai rawit atau sambal.',
                          ),
                        ]
                        // ================= GETHUK =================
                        else if (isGethuk) ...[
                          Text(
                            'Jajanan manis dari singkong yang ditumbuk, dicampur gula dan parutan kelapa, lembut dan legit.',
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Jawa',
                                'Tengah',
                              ),
                              _buildInfoCard(Icons.people, '4', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Mudah', ''),
                            ],
                          ),

                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),

                          _buildIngredientItem('1. ', '500 g', ' singkong'),
                          _buildIngredientItem('2. ', '100 g', ' gula pasir'),
                          _buildIngredientItem('3. ', '½ sdt', ' garam'),
                          _buildIngredientItem(
                            '4. ',
                            '50 g',
                            ' kelapa parut kukus',
                          ),

                          const SizedBox(height: 32),
                          _sectionTitle('Cara membuat :'),

                          _buildStep(
                            '1. Kukus singkong',
                            'Kukus singkong hingga empuk, lalu haluskan selagi masih hangat.',
                          ),

                          _buildStep(
                            '2. Campurkan bahan',
                            'Campurkan singkong halus dengan gula dan garam, aduk hingga rata.',
                          ),

                          _buildStep(
                            '3. Bentuk gethuk',
                            'Cetak atau bentuk gethuk sesuai selera.',
                          ),

                          _buildStep(
                            '4. Sajikan',
                            'Taburi dengan kelapa parut kukus sebelum disajikan.',
                          ),
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
                              _buildInfoCard(
                                Icons.location_on,
                                'Sumatra',
                                'Barat',
                              ),
                              _buildInfoCard(Icons.people, '6', 'porsi'),
                              _buildInfoCard(Icons.layers, 'Standar', ''),
                            ],
                          ),
                          const SizedBox(height: 36),
                          _sectionTitle('Bahan - bahan :'),
                          _buildIngredientItem('1. ', '1 kg', ' daging sapi'),
                          _buildIngredientItem(
                            '2. ',
                            '1 liter',
                            ' santan kental dari 3 butir kelapa tua',
                          ),
                          _buildIngredientItem(
                            '3. ',
                            '500 ml',
                            ' santan encer',
                          ),
                          _buildIngredientItem(
                            '4. ',
                            '2 lembar',
                            ' daun kunyit, simpulkan',
                          ),
                          _buildIngredientItem(
                            '5. ',
                            '5 lembar',
                            ' daun jeruk purut',
                          ),
                          _buildIngredientItem(
                            '6. ',
                            '2 batang',
                            ' serai, memarkan',
                          ),
                          _buildIngredientItem(
                            '7. ',
                            '3 cm',
                            ' lengkuas, memarkan',
                          ),
                          _buildIngredientItem('8. ', 'Garam', ' secukupnya'),
                          _buildIngredientItem(
                            '9. ',
                            'Gula',
                            ' merah secukupnya',
                          ),
                          const SizedBox(height: 28),
                          _sectionTitle('Bumbu halus :'),
                          _buildIngredientItem(
                            '1. ',
                            '15 butir',
                            ' bawang merah',
                          ),
                          _buildIngredientItem(
                            '2. ',
                            '8 siung',
                            ' bawang putih',
                          ),
                          _buildIngredientItem(
                            '3. ',
                            '10 butir',
                            ' kemiri, sangrai',
                          ),
                          _buildIngredientItem('4. ', '5 cm', ' jahe'),
                          _buildIngredientItem('5. ', '3 cm', ' kunyit'),
                          _buildIngredientItem('6. ', '2 sdm', ' ketumbar'),
                          _buildIngredientItem('7. ', '1 sdt', ' jintan'),
                          _buildIngredientItem(
                            '8. ',
                            '10 buah',
                            ' cabai merah keriting',
                          ),
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

  Widget _circleButton({
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
              ? const Color(0xFFFFC107) // Warna kuning untuk favorit
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

  Widget _buildStep(String title, String desc) {
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
