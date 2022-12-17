import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class PoliticsPage extends StatelessWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Center(
        child:  Text("En construcción ..."),
      ),
    );
  }
}
