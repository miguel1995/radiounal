import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Menu(),
        appBar: const AppBarRadio(),
        body: Column(children: [
          Text("Mi Texto"),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/content');
              },
              child: const Text('Launch screen'),
            ),
          ),
        ]));
  }
}
