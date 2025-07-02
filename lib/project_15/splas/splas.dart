import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:futsal_56/project_15/main/dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
      _navigate();
    });
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await SharedPref.hasToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? const HomeScreen() : const Login(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 2),
          tween: Tween<double>(begin: 0.8, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              curve: Curves.easeIn,
              child: Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/image/logo2.png',
                      width: 180,
                      height: 180,
                    ),
                    const Spacer(),
                    const SafeArea(
                      child: Text(
                        "v 1.0.0",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
