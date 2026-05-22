import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {

  // =====================================================
  // CONTROLLERS
  // =====================================================

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  // =====================================================
  // STATE
  // =====================================================

  final isPasswordHidden =
      true.obs;

  final isLoading =
      false.obs;

  // =====================================================
  // SUPABASE
  // =====================================================

  final supabase =
      Supabase.instance.client;

  // =====================================================
  // TOGGLE PASSWORD
  // =====================================================

  void togglePasswordVisibility() {

    isPasswordHidden.value =
        !isPasswordHidden.value;
  }

  // =====================================================
  // LOGIN EMAIL PASSWORD
  // =====================================================

  Future<void> login() async {

    final email =
        usernameController.text.trim();

    final password =
        passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {

      Get.snackbar(

        'Gagal',

        'Email dan password wajib diisi',

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.red,

        colorText:
            Colors.white,
      );

      return;
    }

    try {

      isLoading.value = true;

      FocusManager.instance.primaryFocus
          ?.unfocus();

      await supabase.auth.signInWithPassword(

        email: email,

        password: password,
      );

      Get.snackbar(

        'Berhasil',

        'Login berhasil',

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.green,

        colorText:
            Colors.white,
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (Get.isSnackbarOpen) {

        Get.closeAllSnackbars();
      }

      Get.offAllNamed('/home');
    }

    on AuthException catch (e) {

      Get.snackbar(

        'Login Gagal',

        e.message,

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.red,

        colorText:
            Colors.white,
      );
    }

    catch (e) {

      Get.snackbar(

        'Error',

        e.toString(),

        snackPosition:
            SnackPosition.BOTTOM,

        backgroundColor:
            Colors.red,

        colorText:
            Colors.white,
      );
    }

    finally {

      isLoading.value = false;
    }
  }

  // =====================================================
  // FORGOT PASSWORD
  // =====================================================

  void forgotPassword() {}

  // =====================================================
  // GOOGLE LOGIN
  // =====================================================

  Future<void> loginWithGoogle() async {

    await supabase.auth.signInWithOAuth(

      OAuthProvider.google,

      redirectTo:

          kIsWeb

              ? 'http://localhost:3000'

              : 'io.supabase.flutterquickstart://login-callback/',
    );
  }

  // =====================================================
  // FACEBOOK LOGIN
  // =====================================================

  Future<void> loginWithFacebook() async {

    await supabase.auth.signInWithOAuth(

      OAuthProvider.facebook,

      redirectTo:

          kIsWeb

              ? 'http://localhost:3000'

              : 'io.supabase.flutterquickstart://login-callback/',
    );
  }

  // =====================================================
  // GO TO SIGNUP
  // =====================================================

  void goToSignUp() {

    FocusManager.instance.primaryFocus
        ?.unfocus();

    Future.delayed(
      const Duration(milliseconds: 300),

      () {

        Get.toNamed('/signup');
      },
    );
  }

  // =====================================================
  // CLOSE
  // =====================================================

  @override
  void onClose() {

    usernameController.dispose();

    passwordController.dispose();

    super.onClose();
  }
}