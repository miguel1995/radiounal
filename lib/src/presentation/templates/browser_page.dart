import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
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
  bool isDarkMode = false;

  @override
  void dispose() {
    _controllerQuery.dispose();
    super.dispose();
  }

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeMethod().then((value) {
      setState(() {
        isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });
    return Scaffold(
      backgroundColor: Color(0x00000000),

      extendBodyBehindAppBar: true,

      // extendBodyBehindAppBar: true,
      endDrawer: Menu(),
      appBar: AppBarRadio(enableBack: true),
      body: Container(
          // padding: EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode
                  ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                  : "assets/images/fondo_blanco_amarillo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            //color: Colors.purple,

            padding: EdgeInsets.only(left: 20, right: 20, top: 120),
            child: Column(children: [
              drawSearchField(),
              Container(
                //color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30, bottom: 0),
                child: Text(
                  "Explorando el contenido",
                  style: TextStyle(
                    shadows: [
                      Shadow(
                          color: isDarkMode
                              ? Color(0xFFFFFFFF)
                              : Color(0xFF121C4A),
                          offset: const Offset(0, -5))
                    ],
                    color: Colors.transparent,
                    decorationThickness: 2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decorationColor: const Color(0xFFFCDC4D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              drawMainFilters()
            ]),
          )),
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
          decoration: getFieldDecoration("Ingrese su busqueda"),
          style: TextStyle(color: Color(0xFF121C4A)),
        )),
        if (isFiltro)
          Container(
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 3)),
              child: InkWell(
                  onTap: () {
                    if (_controllerQuery.value.text.isNotEmpty) {
                      showFilterDialog(context);
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.all(9),
                      child: SvgPicture.asset(
                          'assets/icons/icono_filtro_buscador.svg',
                          width: 25))))
      ],
    );
  }

  Widget drawMainFilters() {
    return Expanded(
      child: GridView.count(
          padding: const EdgeInsets.only(bottom: 100),
          childAspectRatio: (1 / 0.5),

          crossAxisCount: 2,
          children: [
            drawFrecuenciaBtn("Series Podcast",
                {"query": "", "numColumn": 2, "contentType": "SERIES"}),
            drawFrecuenciaBtn("Programas Bogotá 98.5 fm", {
              "query": "",
              "sede": 0,
              "canal": "BOG",
              "area": "TODOS",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Programas Medellín 100.4 fm", {
              "query": "",
              "sede": 0,
              "canal": "MED",
              "area": "TODOS",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Programas Radio Web", {
              "query": "",
              "sede": 0,
              "canal": "WEB",
              "area": "TODOS",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Programas Temáticos", {
              "query": "",
              "sede": 0,
              "canal": "TODOS",
              "area": "TEMATICOS",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Programas de Actualidad", {
              "query": "",
              "sede": 0,
              "canal": "TODOS",
              "area": "ACTUALIDAD",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Programas Musicales", {
              "query": "",
              "sede": 0,
              "canal": "TODOS",
              "area": "MUSICALES",
              "contentType": "PROGRAMAS",
              "numColumn": 2
            }),
            drawFrecuenciaBtn("Centro de Producción Amazonia", {
              "query": "",
              "sede": 490,
              "canal": "TODOS",
              "area": "TODOS",
              "contentType": "EMISIONES",
              "numColumn": 1
            }),
            drawFrecuenciaBtn("Centro de Producción Manizales", {
              "query": "",
              "sede": 492,
              "canal": "TODOS",
              "area": "TODOS",
              "contentType": "EMISIONES",
              "numColumn": 1
            }),
            drawFrecuenciaBtn("Centro de Producción Orinoquia", {
              "query": "",
              "sede": 493,
              "canal": "TODOS",
              "area": "TODOS",
              "contentType": "EMISIONES",
              "numColumn": 1
            }),
            drawFrecuenciaBtn("Centro de Producción Palmira", {
              "query": "",
              "sede": 489,
              "canal": "TODOS",
              "area": "TODOS",
              "contentType": "EMISIONES",
              "numColumn": 1
            }),
            drawFrecuenciaBtn("Lo más Escuchado",
                {"contentType": "MASESCUCHADO", "numColumn": 1})
          ]),
    );
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFFA6AABB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            if (_controllerQuery.value.text.isNotEmpty) {
              Navigator.pushNamed(context, "/browser-result",
                  arguments: ScreenArguments('NONE', "Resultados", 1, element: {
                    "query": _controllerQuery.value.text,
                    "contentType": "ELASTIC",
                    "numColumn": 1
                  }));
            }
          },
          icon: SvgPicture.asset(
            "assets/icons/icono_lupa_buscador_azul.svg",
            width: 25,
          ),
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
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              width: 3,
              color: isDarkMode ? Color(0x00FF0000) : Color(0xFF121C4A)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10));
  }

  showFilterDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return FilterDialog(callBackDialog);
        });
  }

  callBackDialog(int sede, String canal, String area, String filterString) {
    Navigator.pushNamed(context, "/browser-result",
        arguments: ScreenArguments('NONE', 'Resultados', 1, element: {
          "query": _controllerQuery.value.text,
          "sede": sede,
          "canal": canal,
          "area": area,
          "contentType": "ELASTIC",
          "numColumn": 1,
          "filterString": filterString
        }));
  }

  Widget drawFrecuenciaBtn(String texto, Map<String, dynamic> mapFilter) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/browser-result",
              arguments: ScreenArguments('NONE', texto, 1, element: mapFilter));
        },
        child: SizedBox(
            height: 100,
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: RadialGradient(radius: 1, colors: [
                    isDarkMode ? Color(0xFFFCDC4D) : Color(0xff216278),
                    isDarkMode ? Color(0xFFFFCC17) : Color(0xff121C4A)
                  ]),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff121C4A).withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset:
                          const Offset(10, 10), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  texto,
                  style: TextStyle(
                      color: isDarkMode ? Color(0xFF121C4A) : Colors.white,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ))));
  }
}
