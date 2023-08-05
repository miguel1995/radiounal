import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/presentation/partials/switch_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {


 bool isDarkMode =false;

@override
  void initState() {print('=====================configurations_page');
    // TODO: implement initState
    var brightness = SchedulerBinding.instance.window.platformBrightness;
  isDarkMode = brightness == Brightness.dark;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      endDrawer: Menu(),
      appBar:  AppBarRadio(enableBack:true),
      body: Container(
        padding: EdgeInsets.only(top: 20,bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [drawConfiguracion(), drawAcerca()],
          ),
        ),
      ),
    );
  }

  Widget drawConfiguracion() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Configuración",
            style: TextStyle(
              shadows: [
                Shadow(
                    color: Theme.of(context).primaryColor,
                    offset: const Offset(0, -5))
              ],
              color: Colors.transparent,
              decorationThickness: 2,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decorationColor: Color(isDarkMode?0xff121C4A:0xFFFCDC4D),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      // sets theme mode to light
                      AdaptiveTheme.of(context).setLight();
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                              radius: 1,
                              colors: [Color(0xfffbdd5a), Color(0xffffcc17)]),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color:  Color(isDarkMode?0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Modo Claro",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        )))),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      // sets theme mode to dark
                      AdaptiveTheme.of(context).setDark();
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient:  RadialGradient(
                              radius: 1,
                              colors: [Color(0xff1b4564), Color(isDarkMode?0xFFFCDC4D:0xff121C4A)]),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color:  Color(isDarkMode?0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: const Text("Modo Oscuro",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white))))),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                "Notificaciones",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
              const SwitchButton()
            ]))
      ],
    );
  }

  Widget drawAcerca() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Acerca de esta App",
            style: TextStyle(
              shadows: [
                Shadow(
                    color: Theme.of(context).primaryColor,
                    offset: const Offset(0, -5))
              ],
              color: Colors.transparent,
              decorationThickness: 2,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decorationColor: Color(isDarkMode?0xff121C4A:0xFFFCDC4D),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _launchURL(
                "https://play.google.com/store/apps/developer?id=Universidad+Nacional+de+Colombia&hl=es_CO&gl=US");
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
              child: Row(children: [
                Text(
                  "Calificar esta aplicación",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                )
              ])),
        ),
        GestureDetector(
          onTap: () {
            Share.share(
                "https://play.google.com/store/apps/developer?id=Universidad+Nacional+de+Colombia&hl=es_CO&gl=US",
                subject: "Radio UNAL - App movil");
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
              child: Row(children: [
                Text(
                  "Compartir esta aplicación",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                )
              ])),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/politics");
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
              child: Row(children: [
                Text(
                  "Política de privacidad",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                )
              ])),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/contacts");
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
              child: Row(children: [
                Text(
                  "Contáctenos",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                )
              ])),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/credits");
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
              child: Row(children: [
                Text(
                  "Créditos",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                )
              ])),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 20),
          child:  Text(
            "Versión 1.0.0 (2023)",
            style: TextStyle(
                color: Color(isDarkMode?0xFFFCDC4D:0xff121C4A),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height*0.05,
        )
      ],
    );
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
