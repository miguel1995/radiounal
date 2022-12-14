import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );
  }
}
