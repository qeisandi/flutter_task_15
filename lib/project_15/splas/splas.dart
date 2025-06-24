import 'package:flutter/material.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref.dart';
import 'package:flutter_task_15/project_15/login_regis/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      bool isLogin = await PreferenceHandler.getLogin();
      print('isLogin: $isLogin');
      if (isLogin) {
        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/image/logo2.png'),
            Spacer(),
            SafeArea(child: Text("v 1.0.0", style: TextStyle(fontSize: 10))),
          ],
        ),
      ),
    );
  }
}
