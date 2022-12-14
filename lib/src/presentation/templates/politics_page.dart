import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class PoliticsPage extends StatelessWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Politicas de privacidad'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );;
  }
}
