import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

import '../partials/filter_dialog.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(children: [
          drawSearchField(),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "Explorando el contenido",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decorationColor: Color(0xFFFCDC4D),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          drawMainFilters()
        ]),
      ),
      //bottomNavigationBar: BottomNavigationBarRadio(),
    );
  }

  Widget drawSearchField() {
    return Row(
      children: [
        Expanded(
            child: TextField(
                decoration: getFieldDecoration("Ingrese su busqueda"))),
        Container(
          margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
            child: IconButton(
                onPressed: () {
                  showFilterDialog(context);
                }, icon: const Icon(Icons.filter_alt_outlined, size: 40)))
      ],
    );
  }

  Widget drawMainFilters() {
    return      Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          drawFrecuenciaBtn("Series Podcast"),
          drawFrecuenciaBtn("Programas Bogotá 98.5 fm"),
          drawFrecuenciaBtn("Programas Medellín 100.4 fm"),
          drawFrecuenciaBtn("Programas Radio Web"),
          drawFrecuenciaBtn("Programas Temáticos"),
          drawFrecuenciaBtn("Programas de Actualidad"),
          drawFrecuenciaBtn("Programas Musicales"),
          drawFrecuenciaBtn("Centro de Producción Amazonia"),
          drawFrecuenciaBtn("Centro de Producción Manizales"),
          drawFrecuenciaBtn("Centro de Producción Orinoquia"),
          drawFrecuenciaBtn("Centro de Producción Palmira"),
          drawFrecuenciaBtn("Lo más Escuchado")
        ]
      ),
    );


  }


  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
       ),
        suffixIcon: Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              BorderSide(width: 3, color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Theme.of(context).primaryColor),
        ));
  }

  showFilterDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return FilterDialog(callBackDialog);
        }
    );
  }

  callBackDialog(String sede, String canal, String area){
    //TODO://
  }

  Widget drawFrecuenciaBtn(String texto) {

    return InkWell(
        onTap: () {
          //TODO: realizar busqeuda por filtro
        },
        child: Container(
            alignment: Alignment.center,
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: const RadialGradient(radius: 0.40, colors: [
                Color(0xff1b4564),
                Color(0xff121C4A),
              ]),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff121C4A).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,

            )));
  }

}
