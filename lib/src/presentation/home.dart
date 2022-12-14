

import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/content');
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}


