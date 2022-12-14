import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Glosario'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );;
  }
}
