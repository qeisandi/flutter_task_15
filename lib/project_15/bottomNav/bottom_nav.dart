import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/admin_session/panel_admin.dart';
import 'package:futsal_56/project_15/main/dashboard.dart';
import 'package:futsal_56/project_15/src/bootom_nav_2.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomeScreen(), EditScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.admin_panel_settings, size: 30, color: Colors.white),
        ],
        index: _currentIndex,
        color: const Color(0xff2F5249),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color.fromARGB(255, 85, 167, 122),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
