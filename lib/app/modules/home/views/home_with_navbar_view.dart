import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../controllers/home_with_navbar_controller.dart';

import 'home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../category/views/category_view.dart';
import '../../favorite/views/favorite_view.dart';

class HomeWithNavbar extends GetView<HomeWithNavbarController> {
  const HomeWithNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.currentIndex.value;

      final pages = [
        const HomeView(),
        const HomeView(),
        const CategoryPage(),
        const Favoriteview(),
        const ProfilePage(),
      ];

      return Scaffold(
        body: pages[index],
        extendBody: true,

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),

          child: CurvedNavigationBar(
            index: index,
            height: 70,

            items: <Widget>[
              _navItem(Icons.home, Icons.home_outlined, 0, index),
              _navItem(Icons.explore, Icons.explore_outlined, 1, index),
              _navItem(Icons.apps, Icons.apps_outlined, 2, index),
              _navItem(Icons.bookmark, Icons.bookmark_outline, 3, index),
              _navItem(Icons.person, Icons.person_outline, 4, index),
            ],

            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.transparent,

            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),

            onTap: controller.changeIndex,
          ),
        ),
      );
    });
  }

  Widget _navItem(
    IconData activeIcon,
    IconData inactiveIcon,
    int itemIndex,
    int currentIndex,
  ) {
    final isActive = currentIndex == itemIndex;

    return isActive
        ? Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFB8956A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activeIcon,
              size: 26,
              color: Colors.white,
            ),
          )
        : Icon(
            inactiveIcon,
            size: 26,
            color: Colors.black,
          );
  }
}