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
      bottomNavigationBar: GNav(
          onTabChange: (int index) {
            slidePages(index);
          },
          tabs: [
            GButton(
              icon: Icons.chat,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            )
          ]),
    );
  }
}
