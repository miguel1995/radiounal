import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Configuracion'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );;
  }
}
