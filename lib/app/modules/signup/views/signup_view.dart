import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignUpPage extends GetView<SignUpController> {

  SignUpPage({super.key});

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
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  const SizedBox(height: 20),

                  Image.asset(
                    'assets/logo_santara.png',
                    height: 140,
                    width: 110,
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Santara',

                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5D3A1A),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= NAMA =================

                  _inputField(
                    hint: 'Nama',
                    controller:
                        controller.nameController,
                  ),

                  const SizedBox(height: 16),

                  // ================= EMAIL =================

                  _inputField(
                    hint: 'Email',
                    controller:
                        controller.emailController,

                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // ================= PASSWORD =================

                  GetBuilder<SignUpController>(
                    builder: (controller) => _inputField(
                      hint: 'Password',

                      controller:
                          controller.passwordController,

                      obscure:
                          controller.isPasswordHidden,

                      suffixIcon: IconButton(
                        onPressed:
                            controller
                                .togglePasswordVisibility,

                        icon: Icon(
                          controller.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,

                          color:
                              const Color(0xFF8B7355),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= CONFIRM PASSWORD =================

                  GetBuilder<SignUpController>(
                    builder: (controller) => _inputField(
                      hint:
                          'Konfirmasi password',

                      controller:
                          controller
                              .confirmPasswordController,

                      obscure:
                          controller
                              .isConfirmPasswordHidden,

                      suffixIcon: IconButton(
                        onPressed:
                            controller
                                .toggleConfirmPasswordVisibility,

                        icon: Icon(
                          controller
                                  .isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,

                          color:
                              const Color(0xFF8B7355),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ================= BUTTON =================

                  Container(
                    width: double.infinity,
                    height: 56,

                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10),

                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF6B4423)
                                  .withOpacity(0.3),

                          blurRadius: 12,

                          offset:
                              const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: GetBuilder<SignUpController>(
                      builder: (controller) => ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6B4423),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),

                          elevation: 0,
                        ),

                        onPressed:
                            controller.isLoading
                                ? null
                                : controller.signUp,

                        child:
                            controller.isLoading

                                ? const SizedBox(
                                    width: 22,
                                    height: 22,

                                    child:
                                        CircularProgressIndicator(
                                      color:
                                          Colors.white,

                                      strokeWidth:
                                          2.5,
                                    ),
                                  )

                                : const Text(
                                    'Daftar',

                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight
                                              .w600,

                                      color:
                                          Colors.white,
                                    ),
                                  ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================= DIVIDER =================

                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 1.2,

                          color:
                              const Color(0xFF8B7355)
                                  .withOpacity(0.25),
                        ),
                      ),

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(
                                horizontal: 14),

                        child: Text(
                          'Atau',

                          style: TextStyle(
                            color:
                                Color(0xFF8B7355),

                            fontSize: 14,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 1.2,

                          color:
                              const Color(0xFF8B7355)
                                  .withOpacity(0.25),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ================= SOCIAL =================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      _socialButton(
                        imagePath:
                            'assets/facebook_icon.png',

                        onTap:
                            controller
                                .signUpWithFacebook,
                      ),

                      const SizedBox(width: 16),

                      _socialButton(
                        imagePath:
                            'assets/google_icon.png',

                        onTap:
                            controller
                                .signUpWithGoogle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // ================= LOGIN =================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(
                        'Sudah punya akun? ',

                        style: TextStyle(
                          color:
                              Color(0xFF8B7355),

                          fontSize: 14,
                        ),
                      ),

                      GestureDetector(
                        onTap:
                            controller.goToLogin,

                        child: const Text(
                          'Masuk',

                          style: TextStyle(
                            color:
                                Color(0xFF5D3A1A),

                            fontSize: 14,

                            fontWeight:
                                FontWeight.bold,
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

  // =====================================================
  // INPUT FIELD
  // =====================================================

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType =
        TextInputType.text,
    Widget? suffixIcon,
  }) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.06),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,

        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF5D3A1A),
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: TextStyle(
            color:
                const Color(0xFF8B7355)
                    .withOpacity(0.5),

            fontSize: 14,
          ),

          suffixIcon: suffixIcon,

          filled: true,
          fillColor:
              const Color(0xFFFFF9F0),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),

            borderSide: const BorderSide(
              color: Color(0xFF8B7355),
              width: 1.2,
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),

            borderSide: const BorderSide(
              color: Color(0xFF8B7355),
              width: 1.2,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),

            borderSide: const BorderSide(
              color: Color(0xFF5D3A1A),
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // SOCIAL BUTTON
  // =====================================================

  Widget _socialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {

    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(10),

      child: Container(
        width: 56,
        height: 56,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(10),

          border: Border.all(
            color:
                const Color(0xFF8B7355)
                    .withOpacity(0.25),

            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.06),

              blurRadius: 6,

              offset:
                  const Offset(0, 2),
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