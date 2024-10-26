// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:ayurveda/screens/login.dart';
import 'package:ayurveda/screens/patient_list.dart';
import 'package:ayurveda/screens/register.dart';
import 'package:ayurveda/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/patient-list', page: () => PatientList()),
      ],
      initialRoute: "/",
    );
  }
}
