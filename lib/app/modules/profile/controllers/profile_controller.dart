import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase = Supabase.instance.client;

  // =====================================================
  // BACK
  // =====================================================

  void goBack() {
    Get.back();
  }

  // =====================================================
  // EDIT PROFILE
  // =====================================================

  void toEditProfile() {
    Get.toNamed('/edit-profile');
  }

  // =====================================================
  // HISTORY
  // =====================================================

  void toRiwayat() {
    Get.toNamed('/history');
  }

  // =====================================================
  // ACCOUNT INFO
  // =====================================================

  void toInfoAkun() {
    Get.toNamed('/account-info');
  }

  // =====================================================
  // ACCOUNT SECURITY
  // =====================================================

  void toKeamananAkun() {
    Get.toNamed('/account-security');
  }

  // =====================================================
  // FAVORITE
  // =====================================================

  void toKoleksi() {
    Get.toNamed('/favorite');
  }

  // =====================================================
  // LOGOUT DIALOG
  // =====================================================

  void showLogoutDialog() {
    Get.dialog(
      _LogoutDialog(),

      barrierDismissible: true,

      barrierColor: const Color(0x4D000000),
    );
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',

        e.toString(),

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );
    }
  }
}

class _LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,

        child: Container(
          width: MediaQuery.of(context).size.width * 0.78,

          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),

          decoration: BoxDecoration(
            color: const Color(0xFFFFEED6),

            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),

                blurRadius: 12,

                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Text(
                'Anda yakin ingin keluar dari\nakun ini?',

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.w700,

                  color: Color(0xFF7A4A2E),

                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  // BUTTON YA
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.find<ProfileController>().logout(),

                      child: Container(
                        height: 44,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: const Color(0xFFD8A77B),

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Text(
                          'Ya',

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: FontWeight.w700,

                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // BUTTON TIDAK
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),

                      child: Container(
                        height: 44,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: const Color(0xFFE6BE97),

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Text(
                          'Tidak',

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: FontWeight.w700,

                            color: Color(0xFF7A4A2E),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
