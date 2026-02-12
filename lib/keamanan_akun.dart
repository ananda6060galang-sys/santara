import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeamananAkunPage extends StatelessWidget {
  const KeamananAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        size: 22,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pengaturan Keamanan",
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.5,
                    color: const Color(0xFF8B5A3C).withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

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
                    context,
                    icon: CupertinoIcons.lock,
                    title: "Ubah Password",
                    onTap: () {},
                  ),
                  _divider(),
                  _buildActionTile(
                    context,
                    icon: CupertinoIcons.shield,
                    title: "Verifikasi Dua Langkah",
                    onTap: () {},
                  ),
                  _divider(),
                  _buildActionTile(
                    context,
                    icon: CupertinoIcons.device_phone_portrait,
                    title: "Perangkat Terhubung",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Aktivitas",
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.5,
                    color: const Color(0xFF8B5A3C).withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: CupertinoIcons.clock,
                    title: "Terakhir Login",
                    value: "Hari ini, 09:42",
                  ),
                  _divider(),
                  _buildInfoTile(
                    icon: CupertinoIcons.location,
                    title: "Lokasi Login",
                    value: "Malang, Indonesia",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
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
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF8B5A3C),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF8B5A3C),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: Colors.grey.shade300,
      ),
    );
  }
}
