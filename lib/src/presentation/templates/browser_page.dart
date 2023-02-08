import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';



class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child:  Column(
          children: [
           drawSearchField()
          ]
        ),
      ),
      //bottomNavigationBar: BottomNavigationBarRadio(),

    );
  }

  Widget drawSearchField(){

    return
      Row(
        children: [
          Expanded(child:
      TextField(
        decoration: getFieldDecoration("Ingrese su busqueda")
      )),
Container(
    decoration:BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
    child:IconButton(
              onPressed: (){
              },
              icon: const Icon(Icons.filter_alt_outlined)
          ))
        ],
      );
  }

  InputDecoration getFieldDecoration(String hintText) {

    return InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        suffixIcon: Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(width: 2, color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(width: 2, color: Theme.of(
              context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(width: 1, color: Theme.of(context).primaryColor),
        ));
  }


}
