import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vkachat_supa/models/profile.dart';
import 'package:vkachat_supa/pages/chat_page.dart';
import 'package:vkachat_supa/pages/profile_page.dart';
import 'package:vkachat_supa/pages/profiles_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    ProfilesPage(),
    ProfilePage(),
  ];

  slidePages(int index) {
    setState(() {
      currentPage = index;
    });
  }

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .bottomAppBarColor, // Используйте цвет BottomAppBar из темы
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              activeColor:
                  Theme.of(context).primaryColor, // Цвет активного элемента
              color: Colors.grey, // Цвет неактивных элементов
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabs: [
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                  activeBorder: Border.all(color: Colors.indigo),
                  iconActiveColor: Colors.white,
                  textColor: Colors.white,
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  activeBorder: Border.all(color: Colors.indigo),
                  iconActiveColor: Colors.white,
                  textColor: Colors.white,
                ),
              ],
              selectedIndex: currentPage,
              onTabChange: (index) {
                slidePages(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
