import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Center(
        child:  Text("En construcción ..."),
      ),
      bottomNavigationBar: BottomNavigationBarRadio(),

    );;
  }
}
