import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/presentation/splash.dart';

class BaseWidget extends StatelessWidget {
  final Widget child;
  const BaseWidget({required this.child});
  @override
  Widget build(BuildContext context) {
;

    return Scaffold(
        drawer: const Menu(),
        appBar: const AppBarRadio(),
        body: child,
        bottomNavigationBar: BottomNavigationBarRadio());
  }
}
