

import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:audioplayers/audioplayers.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        drawer: const Menu(),
        appBar: const AppBarRadio(),
        body: Column(children: [
          Text("Mi Texto"),
          Center(
            child: ElevatedButton(
              onPressed:  () async{
                Navigator.pushNamed(context, '/content');
              },
              child: const Text('Launch screen'),
            ),
          ),
        ]),

    bottomNavigationBar: const BottomNavigationBarRadio(),

    );
  }
}





