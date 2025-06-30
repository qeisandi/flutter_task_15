import 'package:flutter/material.dart';
import 'package:flutter_task_15/project_15/main/add.dart';
import 'package:flutter_task_15/project_15/main/add_sc.dart';
import 'package:flutter_task_15/project_15/main/book_sc.dart';
import 'package:flutter_task_15/project_15/main/dashboard.dart';
import 'package:flutter_task_15/project_15/main/edit.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Add(),
    EditScreen(),
    BookSc(),
    AddSc(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color(0xff039EFD),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_outlined),
            label: 'Book Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Add Schedule',
          ),
        ],
      ),
    );
  }
}
