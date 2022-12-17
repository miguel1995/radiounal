import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      appBar: const AppBarRadio(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/detail');
          },
          child: const Text('IR A DETALLE'),
        ),
      ),
    );
  }
}
