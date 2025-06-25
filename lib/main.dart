import 'package:flutter/material.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:flutter_task_15/project_15/bottomNav/bottom_nav.dart';
import 'package:flutter_task_15/project_15/login_regis/login.dart';
import 'package:flutter_task_15/project_15/login_regis/register.dart';
import 'package:flutter_task_15/project_15/main/add.dart';
import 'package:flutter_task_15/project_15/main/dashboard.dart';
import 'package:flutter_task_15/project_15/splas/splas.dart'; // pastikan path-nya benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _home;

  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  void _startAppFlow() async {
    await Future.delayed(const Duration(seconds: 3));

    final isLoggedIn = await SharedPref.hasToken();

    setState(() {
      _home = isLoggedIn ? const BottomNavScreen() : const Login();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: _home ?? const Splash(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        Add.id: (context) => Add(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
    );
  }
}
