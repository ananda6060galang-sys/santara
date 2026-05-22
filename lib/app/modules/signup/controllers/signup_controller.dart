import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpController extends GetxController {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  bool isLoading = false;

  final supabase = Supabase.instance.client;

  // =====================================================
  // TOGGLE PASSWORD
  // =====================================================

  void togglePasswordVisibility() {

    isPasswordHidden =
        !isPasswordHidden;

    update();
  }

  void toggleConfirmPasswordVisibility() {

    isConfirmPasswordHidden =
        !isConfirmPasswordHidden;

    update();
  }

  // =====================================================
  // SIGN UP
  // =====================================================

  Future<void> signUp() async {

    final name =
        nameController.text.trim();

    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();

    // VALIDASI
    if (
        name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty
    ) {

      Get.snackbar(
        'Gagal',
        'Semua field wajib diisi',

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    // PASSWORD TIDAK SAMA
    if (password != confirmPassword) {

      Get.snackbar(
        'Gagal',
        'Konfirmasi password tidak cocok',

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    try {

      isLoading = true;
      update();

      // TUTUP KEYBOARD
      FocusManager.instance.primaryFocus?.unfocus();

      // REGISTER
      await supabase.auth.signUp(
        email: email,
        password: password,

        data: {
          'name': name,
        },
      );

      // SUCCESS
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat',

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // TUNGGU
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // DELETE CONTROLLER DULU
      if (Get.isRegistered<SignUpController>()) {

        Get.delete<SignUpController>();
      }

      // PINDAH
      Get.offAllNamed('/login');
    }

    on AuthException catch (e) {

      Get.snackbar(
        'Register Gagal',
        e.message,

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    finally {

      isLoading = false;
      update();
    }
  }

  // =====================================================
  // GOOGLE SIGN UP
  // =====================================================

  Future<void> signUpWithGoogle() async {

    try {

      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,

        redirectTo:
            'io.supabase.flutter://login-callback',
      );
    }

    catch (e) {

      Get.snackbar(
        'Google Sign Up Error',
        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =====================================================
  // FACEBOOK SIGN UP
  // =====================================================

  Future<void> signUpWithFacebook() async {

    try {

      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,

        redirectTo:
            'io.supabase.flutter://login-callback',
      );
    }

    catch (e) {

      Get.snackbar(
        'Facebook Sign Up Error',
        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =====================================================
  // GO TO LOGIN
  // =====================================================

  void goToLogin() {

    FocusManager.instance.primaryFocus?.unfocus();

    Future.delayed(
      const Duration(milliseconds: 300),

      () {

        if (Get.isRegistered<SignUpController>()) {

          Get.delete<SignUpController>();
        }

        Get.offAllNamed('/login');
      },
    );
  }
}