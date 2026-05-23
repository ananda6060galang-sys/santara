import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpController extends GetxController {

  // CONTROLLERS

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // STATE

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isLoading = false;

  // SUPABASE

  final supabase = Supabase.instance.client;

  // TOGGLE PASSWORD

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;

    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden = !isConfirmPasswordHidden;

    update();
  }

  // SIGN UP EMAIL PASSWORD


  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // VALIDATION

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Gagal',

        'Semua field wajib diisi',

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );

      return;
    }

    // PASSWORD CHECK

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

      FocusManager.instance.primaryFocus?.unfocus();

      // REGISTER

      await supabase.auth.signUp(
        email: email,

        password: password,

        data: {'name': name},
      );

      // SUCCESS

      Get.snackbar(
        'Berhasil',

        'Akun berhasil dibuat',

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.green,

        colorText: Colors.white,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (Get.isRegistered<SignUpController>()) {
        Get.delete<SignUpController>();
      }

      Get.offAllNamed('/login');
    } on AuthException catch (e) {
      Get.snackbar(
        'Register Gagal',

        e.message,

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',

        e.toString(),

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );
    } finally {
      isLoading = false;

      update();
    }
  }

  // GOOGLE SIGN UP

  Future<void> signUpWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,

        redirectTo: kIsWeb
            ? 'http://localhost:3000'
            : 'io.supabase.flutterquickstart://login-callback/',

        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar(
        'Google Sign Up Error',

        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // FACEBOOK SIGN UP

  Future<void> signUpWithFacebook() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,

        redirectTo: kIsWeb
            ? 'http://localhost:3000'
            : 'io.supabase.flutterquickstart://login-callback/',

        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar(
        'Facebook Sign Up Error',

        e.toString(),

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // GO TO LOGIN

  void goToLogin() {
    FocusManager.instance.primaryFocus?.unfocus();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.isRegistered<SignUpController>()) {
        Get.delete<SignUpController>();
      }

      Get.offAllNamed('/login');
    });
  }

  // CLOSE

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
