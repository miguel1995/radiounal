import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );;
  }
}
