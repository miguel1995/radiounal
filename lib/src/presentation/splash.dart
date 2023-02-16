

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  _SplashState(){
    Future.delayed(const Duration(milliseconds: 4000),(){
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:

      Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xff111b49),
      child: Center(
        child: Image(
          image: const AssetImage('assets/images/splash.png'),
          width: MediaQuery.of(context).size.width*0.8,
        )
      )
      ),

    );
  }

}
