import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_page.dart';
import 'profile_page.dart' as profile_page;
import 'kategori.dart';
import 'favorit.dart';

class HomeWithNavbar extends StatefulWidget {
  final int initialIndex;
  final String? selectedCategory;

  const HomeWithNavbar({
    super.key,
    this.initialIndex = 0,
    this.selectedCategory,
  });

  @override
  State<HomeWithNavbar> createState() => _HomeWithNavbarState();
}

class _HomeWithNavbarState extends State<HomeWithNavbar> {
  late int _currentIndex;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
  final GlobalKey<HomePageState> _searchPageKey = GlobalKey<HomePageState>();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _pages = [
      HomePage(key: _homePageKey),
      HomePage(key: _searchPageKey),
      CategoryPage(selectedCategory: widget.selectedCategory),
      const KoleksiPage(),
      const profile_page.ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
          key: _bottomNavigationKey,
          index: _currentIndex,
          height: 70.0,
          items: <Widget>[
            // Home Icon
            _currentIndex == 0
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.home_outlined,
                    size: 26,
                    color: Colors.black,
                  ),

            // Search Icon
            _currentIndex == 1
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.explore,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.explore_outlined,
                    size: 26,
                    color: Colors.black,
                  ),

            // Kategori Icon
            _currentIndex == 2
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.apps,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.apps,
                    size: 26,
                    color: Colors.black,
                  ),

            // Favorite Icon
            _currentIndex == 3
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.bookmark_outline,
                    size: 26,
                    color: Colors.black,
                  ),

            // Profile Icon
            _currentIndex == 4
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8956A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.person_outline,
                    size: 26,
                    color: Colors.black,
                  ),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Jika pindah ke search page, aktifkan dropdown
            if (index == 1) {
              Future.delayed(const Duration(milliseconds: 100), () {
                _searchPageKey.currentState?.activateSearch();
              });
            }
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
