import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController
    extends GetxController
    with GetTickerProviderStateMixin {

  // =====================================================
  // CONTROLLERS
  // =====================================================

  late AnimationController
      logoController;

  late AnimationController
      textController;

  late AnimationController
      floatController;

  late AnimationController
      bgController;

  // =====================================================
  // ANIMATIONS
  // =====================================================

  late Animation<double>
      logoScale;

  late Animation<double>
      logoOpacity;

  late Animation<double>
      floatAnim;

  late Animation<Offset>
      textSlide;

  late Animation<double>
      textOpacity;

  late Animation<Alignment>
      bgAlignTop;

  late Animation<Alignment>
      bgAlignBottom;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {

    super.onInit();

    _initControllers();

    _initAnimations();

    _startAnimations();

    _navigateToNextPage();
  }

  // =====================================================
  // INIT CONTROLLERS
  // =====================================================

  void _initControllers() {

    logoController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
              milliseconds: 900),
    );

    textController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
              milliseconds: 700),
    );

    floatController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
              seconds: 3),
    )..repeat(reverse: true);

    bgController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
              seconds: 6),
    )..repeat(reverse: true);
  }

  // =====================================================
  // INIT ANIMATIONS
  // =====================================================

  void _initAnimations() {

    logoScale =
        Tween<double>(
          begin: 0.7,
          end: 1.0,
        ).animate(

      CurvedAnimation(

        parent:
            logoController,

        curve:
            Curves.easeOutBack,
      ),
    );

    logoOpacity =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(

      CurvedAnimation(

        parent:
            logoController,

        curve:
            Curves.easeIn,
      ),
    );

    floatAnim =
        Tween<double>(
          begin: -6,
          end: 6,
        ).animate(

      CurvedAnimation(

        parent:
            floatController,

        curve:
            Curves.easeInOut,
      ),
    );

    textSlide =
        Tween<Offset>(

      begin:
          const Offset(0, 0.6),

      end:
          Offset.zero,

    ).animate(

      CurvedAnimation(

        parent:
            textController,

        curve:
            Curves.easeOut,
      ),
    );

    textOpacity =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(

      CurvedAnimation(

        parent:
            textController,

        curve:
            Curves.easeIn,
      ),
    );

    bgAlignTop =
        Tween<Alignment>(

      begin:
          Alignment.topCenter,

      end:
          Alignment.bottomCenter,

    ).animate(bgController);

    bgAlignBottom =
        Tween<Alignment>(

      begin:
          Alignment.bottomCenter,

      end:
          Alignment.topCenter,

    ).animate(bgController);
  }

  // =====================================================
  // START ANIMATIONS
  // =====================================================

  void _startAnimations() {

    logoController.forward();

    Future.delayed(

      const Duration(
          milliseconds: 700),

      () {

        textController.forward();
      },
    );
  }

  // =====================================================
  // NAVIGATION
  // =====================================================

  void _navigateToNextPage() {

    Timer(

      const Duration(seconds: 3),

      () {

        final session =

            Supabase.instance
                .client
                .auth
                .currentSession;

        if (session != null) {

          Get.offAllNamed(
              '/home');
        }

        else {

          Get.offAllNamed(
              '/login');
        }
      },
    );
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void onClose() {

    logoController.dispose();

    textController.dispose();

    floatController.dispose();

    bgController.dispose();

    super.onClose();
  }
}