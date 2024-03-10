

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 4000),
      tween: Tween(begin: 0.0,end: 1.0),

      builder: (context,timer,_) {
        return Visibility(
          visible: timer!=1.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xff111b49),
            padding: EdgeInsets.only(top: 300),
            child: Container(
              child: Image(
                image: const AssetImage('assets/images/splash_transparente.png'),
                width: MediaQuery.of(context).size.width,
              )
            )
            ),
        );
      }
    );

  }

}
