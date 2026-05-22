import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/account_info_controller.dart';

class InfoAkunPage extends GetView<InfoAkunController> {
  const InfoAkunPage({super.key});

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
                    "Info Akun",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.w600,

                      color: Color(0xFF8B5A3C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =====================================================
            // AVATAR
            // =====================================================
            Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    controller.avatarPath,

                    width: 110,

                    height: 110,

                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  controller.name,

                  style: const TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.w600,

                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  controller.email,

                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // =====================================================
            // LABEL
            // =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Informasi Akun",

                  style: TextStyle(
                    fontSize: 13,

                    letterSpacing: 0.5,

                    color: const Color(0xFF8B5A3C).withOpacity(0.6),

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // =====================================================
            // INFO LIST
            // =====================================================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.phone_outlined,

                    title: "Nomor Telepon",

                    value: controller.phone,
                  ),

                  _divider(),

                  _buildListTile(
                    icon: Icons.calendar_month_outlined,

                    title: "Bergabung",

                    value: controller.joinDate,
                  ),

                  _divider(),

                  _buildListTile(
                    icon: Icons.location_on_outlined,

                    title: "Lokasi",

                    value: controller.location,
                  ),

                  _divider(),

                  _buildListTile(
                    icon: Icons.check_circle_outline_rounded,

                    title: "Status",

                    value: controller.status,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LIST TILE
  // =====================================================

  Widget _buildListTile({
    required IconData icon,

    required String title,

    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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
