import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller.bgController,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: controller.bgAlignTop.value,
                end: controller.bgAlignBottom.value,
                colors: const [
                  Color(0xFFFFFBF4),
                  Color(0xFFFFE0B2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: controller.logoOpacity,
                  child: ScaleTransition(
                    scale: controller.logoScale,
                    child: AnimatedBuilder(
                      animation: controller.floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, controller.floatAnim.value),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/logo_santara.png',
                        width: 120,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FadeTransition(
                  opacity: controller.textOpacity,
                  child: SlideTransition(
                    position: controller.textSlide,
                    child: Text(
                      'Santara',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        color: const Color(0xFF5D4037),
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.brown.withOpacity(0.25),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}