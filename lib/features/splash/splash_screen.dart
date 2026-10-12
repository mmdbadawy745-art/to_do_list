

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_list/core/utils/add_constants.dart';
import 'package:to_do_list/features/home/home_screen.dart';
import 'package:to_do_list/features/login/data/user_model.dart';
import 'package:to_do_list/features/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      nextPage();
    });
  }
  
  void nextPage() {
   UserModel? user = Hive.box<UserModel>(AddConstants.userBoxName).get(AddConstants.currentUserKey);

   if (user != null) {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (_) => HomeScreen(userName: user.name),
       ),
     );
   } else {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (_) => const LoginScreen(),
       ),
     );
   }
        
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/icons/Checklist (1).json'),
      ),
    );
  }
}