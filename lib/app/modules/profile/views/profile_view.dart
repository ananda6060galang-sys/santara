import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildSkeleton();
      }

      return Scaffold(
        backgroundColor: const Color(0xFFFDF8F3),
        body: SafeArea(
          child: Stack(
            children: [
              // TOP SECTION BACKGROUND
              Container(
                height: 150,
                decoration: const BoxDecoration(color: Color(0xFFE8D5B7)),
              ),

              // MAIN CONTENT
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 20, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF8B5A3C),
                              size: 22,
                            ),
                            onPressed: controller.goBack,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Profile Saya',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B5A3C),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // PROFILE CARD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // PROFILE PHOTO
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFD4A574),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Obx(() {
                                  if (controller.avatarUrl.value.isNotEmpty) {
                                    return Image.network(
                                      controller.avatarUrl.value,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _buildInitialAvatar();
                                          },
                                    );
                                  }
                                  return _buildInitialAvatar();
                                }),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // NAME & EMAIL (dari supabase tb user )
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.username.value.isEmpty
                                          ? 'User'
                                          : controller.username.value,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C2C2C),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // email pengguna (ambil dari tb user )
                                  Obx(
                                    () => Text(
                                      controller.email.value.isEmpty
                                          ? 'Belum ada email'
                                          : controller.email.value,
                                      style: TextStyle(
                                        fontSize: 13,

                                        color: const Color(
                                          0xFF2C2C2C,
                                        ).withOpacity(0.6),
                                        letterSpacing: 0.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // EDIT BUTTON
                            GestureDetector(
                              onTap: controller.toEditProfile,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDF8F3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF8B5A3C),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // MENU LIST
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.history,
                            title: 'Riwayat',
                            onTap: controller.toRiwayat,
                          ),
                          _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'Info akun',
                            onTap: controller.toInfoAkun,
                          ),
                          _buildMenuItem(
                            icon: Icons.security_outlined,
                            title: 'Keamanan akun',
                            onTap: controller.toKeamananAkun,
                          ),
                          _buildMenuItem(
                            icon: Icons.bookmark_outline,
                            title: 'Koleksi',
                            onTap: controller.toKoleksi,
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Keluar',
                            isLast: true,
                            onTap: controller.showLogoutDialog,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 4.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF8B5A3C), size: 26),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8B5A3C),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF8B5A3C).withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            color: const Color(0xFF8B5A3C).withOpacity(0.15),
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }

  // skeleton loading
  Widget _buildSkeleton() {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(color: Color(0xFFE8D5B7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(width: 180, height: 30, color: Colors.white),
                    const SizedBox(height: 30),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 34),
                    ...List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Container(
                              width: 140,
                              height: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // avatar huruf inisial
  Widget _buildInitialAvatar() {
    String initial = '?';

    if (controller.username.value.isNotEmpty) {
      initial = controller.username.value[0].toUpperCase();
    }

    return Container(
      color: const Color(0xFFD4A574),

      alignment: Alignment.center,

      child: Text(
        initial,

        style: const TextStyle(
          fontSize: 28,

          fontWeight: FontWeight.bold,

          color: Colors.white,
        ),
      ),
    );
  }
}
