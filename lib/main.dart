import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:futsal_56/project_15/admin_session/add.dart';
import 'package:futsal_56/project_15/admin_session/add_sc.dart';
import 'package:futsal_56/project_15/bottomNav/bottom_nav.dart';
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:futsal_56/project_15/login_regis/register.dart';
import 'package:futsal_56/project_15/main/dashboard.dart';
import 'package:futsal_56/project_15/splas/splas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _home = const Splash();

  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  void _startAppFlow() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      final isLoggedIn = await SharedPref.hasToken();

      setState(() {
        _home = isLoggedIn ? BottomNavScreen() : Login();
      });
    } catch (e) {
      debugPrint('Gagal inisialisasi: $e');
      setState(() {
        _home = Login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futsal 56',
      home: _home,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        Add.id: (context) => Add(),
        AddSc.id: (context) => AddSc(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
    );
  }
}
