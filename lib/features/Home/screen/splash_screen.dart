import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mayan/core/pallette/pallete.dart';

import '../../../core/constants/variables.dart';
import 'home_page.dart';

class SplashScreenWidget extends StatefulWidget {

  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {

@override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     checkDate();
//     setState(() {
//
//     });
//
// }


  void initState() {
    
    super.initState();

    // Timer to move to the next screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage())
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,

      body: Center(

        // child: Image.asset('assets/images/Pixelfinish_Logo.png',height: w*0.5,width: w*0.5,), // Splash logo
      ),
    );
  }
}
