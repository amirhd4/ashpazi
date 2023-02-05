import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/widgets/text.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Container(color: SplashScreenInfo.splashBackColor),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget.splashText(SplashScreenInfo.splashText),
              const SizedBox(height: 10.0),
              Image.asset(
                "assets/icons/ashpazi.gif",
                width: 150,
                height: 150,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
