import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFBF5),
              Color(0xFFFFE5C2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // LOGO
                  Image.asset(
                    'assets/logo_santara.png',
                    height: 140,
                    width: 110,
                  ),

                  const SizedBox(height: 2),

                  // TITLE
                  const Text(
                    'Santara',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5D3A1A),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // USERNAME FIELD
                  _inputField(
                    hint: 'Username, atau email',
                    controller: controller.usernameController,
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD FIELD
                  Obx(() => _inputField(
                        hint: 'Password',
                        controller: controller.passwordController,
                        obscure: controller.isPasswordHidden.value,
                        onToggleVisibility:
                            controller.togglePasswordVisibility,
                      )),

                  const SizedBox(height: 26),

                  // LOGIN BUTTON
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B4423).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4423),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: controller.login,
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // DIVIDER
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.2,
                          color: const Color(0xFF8B7355).withOpacity(0.35),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'Atau',
                          style: TextStyle(
                            color: Color(0xFF8B7355),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.2,
                          color: const Color(0xFF8B7355).withOpacity(0.35),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // FORGOT PASSWORD
                  TextButton(
                    onPressed: controller.forgotPassword,
                    child: const Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        color: Color(0xFF5D3A1A),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SOCIAL BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        imagePath: 'assets/facebook_icon.png',
                        onTap: controller.loginWithFacebook,
                      ),
                      const SizedBox(width: 16),
                      _socialButton(
                        imagePath: 'assets/google_icon.png',
                        onTap: controller.loginWithGoogle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // REGISTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tidak punya akun?  ',
                        style: TextStyle(
                          color: const Color(0xFF5D3A1A).withOpacity(0.75),
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: controller.goToSignUp,
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFF5D3A1A),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _inputField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF5D3A1A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF8B7355).withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFFFF9F0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: onToggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF8B7355),
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF8B7355),
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF8B7355),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF5D3A1A),
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _socialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF8B7355).withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}