import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Detalle'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );
  }
}
