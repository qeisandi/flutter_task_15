import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Futsal 56', style: TextStyle(fontFamily: 'Gilroy')),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
    );
  }
}
