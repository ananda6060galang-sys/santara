import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/account_security_controller.dart';

class KeamananAkunPage extends GetView<KeamananAkunController> {
  const KeamananAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // APP BAR
            // =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              child: Stack(
                alignment: Alignment.center,

                children: [
                  Align(
                    alignment: Alignment.centerLeft,

                    child: GestureDetector(
                      onTap: controller.goBack,

                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,

                        size: 20,

                        color: Color(0xFF8B5A3C),
                      ),
                    ),
                  ),

                  const Text(
                    "Keamanan Akun",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.w600,

                      color: Color(0xFF8B5A3C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // SECURITY SECTION
            // =====================================================
            _sectionLabel("Pengaturan Keamanan"),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.lock_outline_rounded,

                    title: "Ubah Password",

                    onTap: () {
                      controller.ubahPassword();
                    },
                  ),

                  _divider(),

                  _buildActionTile(
                    icon: Icons.shield_outlined,

                    title: "Verifikasi Dua Langkah",

                    onTap: controller.verifikasiDuaLangkah,
                  ),

                  _divider(),

                  _buildActionTile(
                    icon: Icons.devices_outlined,

                    title: "Perangkat Terhubung",

                    onTap: controller.perangkatTerhubung,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // ACTIVITY SECTION
            // =====================================================
            _sectionLabel("Aktivitas"),

            const SizedBox(height: 10),

            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.schedule_rounded,

                      title: "Terakhir Login",

                      value: controller.isLoading.value
                          ? "Memuat..."
                          : controller.lastLogin.value,
                    ),

                    _divider(),

                    _buildInfoTile(
                      icon: Icons.location_on_outlined,

                      title: "Lokasi Login",

                      value: controller.isLoading.value
                          ? "Memuat..."
                          : controller.loginLocation.value,
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

  // =====================================================
  // SECTION LABEL
  // =====================================================

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          text,

          style: TextStyle(
            fontSize: 13,

            letterSpacing: 0.5,

            color: const Color(0xFF8B5A3C).withOpacity(0.6),

            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // ACTION TILE
  // =====================================================

  Widget _buildActionTile({
    required IconData icon,

    required String title,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      behavior: HitTestBehavior.opaque,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

        child: Row(
          children: [
            Icon(icon, size: 21, color: const Color(0xFF8B5A3C)),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,

              size: 22,

              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // INFO TILE
  // =====================================================

  Widget _buildInfoTile({
    required IconData icon,

    required String title,

    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      child: Row(
        children: [
          Icon(icon, size: 21, color: const Color(0xFF8B5A3C)),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),

          Text(
            value,

            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DIVIDER
  // =====================================================

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 50),

      child: Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300),
    );
  }
}
