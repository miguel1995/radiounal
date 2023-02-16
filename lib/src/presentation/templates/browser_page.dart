import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';

import '../partials/filter_dialog.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {

  final TextEditingController _controllerQuery = TextEditingController();
  bool isFiltro = false;

  @override
  void dispose() {
    _controllerQuery.dispose();
    super.dispose();
  }

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
                controller: _controllerQuery,
                  onChanged: (String value) async {
                      setState(() {
                        isFiltro = value.isNotEmpty;
                      });
                  },
                decoration: getFieldDecoration("Ingrese su busqueda"))),
        if(isFiltro)
        Container(
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
            child: IconButton(
                onPressed: () {
                  if(_controllerQuery.value.text.isNotEmpty) {
                    showFilterDialog(context);
                  }
                },
                icon: const Icon(Icons.filter_alt_outlined, size: 40)))
      ],
    );
  }

  Widget drawMainFilters() {
    return Expanded(
      child: GridView.count(crossAxisCount: 2, children: [
        drawFrecuenciaBtn("Series Podcast", {"query":"", "contentType":"SERIES"}),
        drawFrecuenciaBtn("Programas Bogotá 98.5 fm",{"query":"","sede": 0, "canal": "BOG", "area": "TODOS", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Programas Medellín 100.4 fm", {"query":"","sede": 0, "canal": "MED", "area": "TODOS", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Programas Radio Web", {"query":"","sede": 0, "canal": "WEB", "area": "TODOS", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Programas Temáticos", {"query":"","sede": 0, "canal": "TODOS", "area": "TEMATICOS", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Programas de Actualidad", {"query":"","sede": 0, "canal": "TODOS", "area": "ACTUALIDAD", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Programas Musicales", {"query":"","sede": 0, "canal": "TODOS", "area": "MUSICALES", "contentType":"PROGRAMAS"}),
        drawFrecuenciaBtn("Centro de Producción Amazonia", {"query":"","sede": 490, "canal": "TODOS", "area": "TODOS", "contentType":"EMISIONES"}),
        drawFrecuenciaBtn("Centro de Producción Manizales", {"query":"","sede": 492, "canal": "TODOS", "area": "TODOS", "contentType":"EMISIONES"}),
        drawFrecuenciaBtn("Centro de Producción Orinoquia", {"query":"","sede": 493, "canal": "TODOS", "area": "TODOS", "contentType":"EMISIONES"}),
        drawFrecuenciaBtn("Centro de Producción Palmira", {"query":"","sede": 489, "canal": "TODOS", "area": "TODOS", "contentType":"EMISIONES"}),
        drawFrecuenciaBtn("Lo más Escuchado", {"contentType":"MASESCUCHADO"})
      ]),
    );
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: InkWell(
          onTap: (){
            if( _controllerQuery.value.text.isNotEmpty){
              Navigator.pushNamed(context, "/browser-result",
                  arguments: ScreenArguments('NONE', "Resultados", 1,
                      element: {"query":_controllerQuery.value.text, "contentType":"ELASTIC"}));
            }

          },
          child: Icon(Icons.search)
        ),
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
        });
  }

  callBackDialog(int sede, String canal, String area) {
    String contentType = "";
    if(canal=="POD"){
      contentType = "EPISODIOS";
    }else{
      contentType = "EMISIONES";
    }
    Navigator.pushNamed(context, "/browser-result",
        arguments: ScreenArguments('NONE', 'Resultados', 1,
            element: {"query":_controllerQuery.value.text,"sede": sede, "canal": canal, "area": area, "contentType": contentType}));
  }

  Widget drawFrecuenciaBtn(String texto, Map<String, dynamic> mapFilter) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/browser-result",
              arguments: ScreenArguments('NONE', texto, 1,
                  element: mapFilter));

        },
        child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
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
