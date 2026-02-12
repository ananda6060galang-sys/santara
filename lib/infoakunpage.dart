import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoAkunPage extends StatelessWidget {
  const InfoAkunPage({super.key});

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
            Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/profile.png",
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Floyd Miles",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "felicia.reid@example.com",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: CupertinoIcons.phone,
                    title: "Nomor Telepon",
                    value: "+62 812-3456-7890",
                  ),
                  _divider(),
                  _buildListTile(
                    icon: CupertinoIcons.calendar,
                    title: "Bergabung",
                    value: "12 Januari 2024",
                  ),
                  _divider(),
                  _buildListTile(
                    icon: CupertinoIcons.location,
                    title: "Lokasi",
                    value: "Malang, Indonesia",
                  ),
                  _divider(),
                  _buildListTile(
                    icon: CupertinoIcons.checkmark_seal,
                    title: "Status",
                    value: "Aktif",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
