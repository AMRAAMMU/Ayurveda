// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:ayurveda/data/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final GlobalController controller = Get.put(GlobalController());

      var res = await controller.checkUserAuthenticated();

      if (res) {
        Get.toNamed("/patient-list");
      } else {
        Get.toNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/ayurveda_icon.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
