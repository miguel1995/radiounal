import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        endDrawer: Menu(),
    appBar:  AppBarRadio(enableBack:true),

      body: Center(
        child:  Text("En construcción ..."),
      )
    );
  }
}
