import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToScreen();
    super.initState();
  }

  ///
  ///  decide navigation
  navigateToScreen() async {
    final prefs = await SharedPreferences.getInstance();
    var isNewUser = prefs.getBool(Constants.isNewUser) ?? true;
    Future.delayed(
      const Duration(seconds: 1),
      () {
        isNewUser
            ? Navigator.pushReplacementNamed(context, '/onboarding')
            : Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Constants.logoImage,
          width: MediaQuery.of(context).size.width * .7,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
