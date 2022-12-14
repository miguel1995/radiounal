import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Menu(),
      ),
      appBar: AppBar(
        title: const Text('Constactenos'),
      ),
      body: const Center(
        child:  Text("En construcción ..."),
      ),
    );;
  }
}
