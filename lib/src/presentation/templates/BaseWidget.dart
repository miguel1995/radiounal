import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/home.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/presentation/splash.dart';

class BaseWidget extends StatefulWidget {
  late final Widget child;
  late BottomNavigationBarRadio bottomBar;
   BaseWidget({Key? key}) : super(key: key);



  @override
  State<BaseWidget> createState() => BaseWidgetState();
}

class BaseWidgetState extends State<BaseWidget> {

  late Widget child;
  late Widget bottomBar;

  setChild(Widget child) {
      print("##### actualizare");
  setState((){
    child = child;
  });


  }

  setBottomBar(Widget bottomBar) {
    setState(() {
      bottomBar = bottomBar;
    });
  }


  @override
  void initState() {
    child = Text("");
    bottomBar = Text("");
  }

  @override
  Widget build(BuildContext context) {

    print(ModalRoute.of(context)?.settings.name);
    print(child.runtimeType);
    print(child.toString());


    return Scaffold(
        body: child,
        bottomNavigationBar: bottomBar
    );
  }
}
