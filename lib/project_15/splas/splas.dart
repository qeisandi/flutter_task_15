import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart'; // Ganti sesuai lokasi SharedPref
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:futsal_56/project_15/main/dashboard.dart'; // Halaman setelah login

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Jalankan navigasi setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  void _navigate() async {
    // Tampilkan splash selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    // Cek token login
    bool isLoggedIn = await SharedPref.hasToken();

    // Pastikan widget masih dalam keadaan mounted
    if (!mounted) return;

    // Arahkan sesuai kondisi login
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image(image: AssetImage('assets/image/logo2.png')),
            Spacer(),
            SafeArea(child: Text("v 1.0.0", style: TextStyle(fontSize: 10))),
          ],
        ),
      ),
    );
  }
}
