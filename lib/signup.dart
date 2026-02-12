import 'package:flutter/material.dart';
import 'home_with_navbar.dart';


void main() {
  runApp(const SantaraApp());
}

class SantaraApp extends StatelessWidget {
  const SantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Santara',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
              // ✅ JARAK SAMPING DIPERLEBAR
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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

                  // EMAIL
                  _inputField(
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD
                  _inputField(
                    hint: 'Password',
                    obscure: true,
                  ),

                  const SizedBox(height: 16),

                  // KONFIRMASI PASSWORD
                  _inputField(
                    hint: 'Konfirmasi password',
                    obscure: true,
                  ),

                  const SizedBox(height: 26),

                  // DAFTAR BUTTON
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeWithNavbar(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                          color: const Color(0xFF8B7355).withOpacity(0.25),
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
                          color: const Color(0xFF8B7355).withOpacity(0.25),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // SOCIAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        imagePath: 'assets/facebook_icon.png',
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _socialButton(
                        imagePath: 'assets/google_icon.png',
                        onTap: () {},
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
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
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF5D3A1A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF8B7355).withOpacity(0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFFFF9F0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
