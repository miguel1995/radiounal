import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  bool isDarkMode = false;

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  void initState() {
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
        backgroundColor: isDarkMode ? const Color(0xFF121C4A) : const Color(0xFFFFFFFF),
        endDrawer: const Menu(),
        appBar: AppBarRadio(enableBack: true),
        body: Container(
            color: isDarkMode ? const Color(0xFF121C4A) : const Color(0xFFFFFFFF),
            padding: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height * 0.8,
            margin: const EdgeInsets.only(top: 30, left: 30),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      "Créditos",
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
                        decorationColor:
                            Color(isDarkMode ? 0xff121C4A : 0xFFFCDC4D),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Rectora: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Dolly Montoya Castaño',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Director Nacional de Unimedios: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Freddy Chaparro Sanabria\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'ffchaparros@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    const Divider(
                      color: Color(0xFFFCDC4D),
                      thickness: 1,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Jefe Oficina de Producción y Realización Radiofónica: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Carlos Emilio Raigoso Camelo\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'ceraigosoca@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Secretaría: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Janeth López Pirajan\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'jlopezpi@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Coordinador Radio UNAL Medellín: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Daniel Iván Longas Arteaga\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'dilongasa@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Producción General Radio UNAL Bogotá: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Wendy Casallas Moreno\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'wlcasallasm@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Producción General Podcast Radio UNAL: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Diana Gabriela Hernández Monroy\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'dihernandezmo@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Producción General Radio Web UNAL: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Julio Cesar Casas Castro\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'jccasasc@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall

                                      // TextStyle(fontWeight: FontWeight.w100,
                                      //    color: Theme.of(context).primaryColor)
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Fonoteca Radio UNAL: \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  TextSpan(
                                      text: 'Pedro Arturo Salazar Díaz\n',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)
                                  ),
                                  TextSpan(
                                      text: 'pasalazard@unal.edu.co',
                                      style:
                                          Theme.of(context).textTheme.bodySmall
                                      ),
                                ],
                              ),
                            )),
                          ],
                        )),
                    const Divider(
                      color: Color(0xFFFCDC4D),
                      thickness: 1,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent

                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Análisis, diseño, desarrollo e implementación de la aplicación: \n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor)),
                                      TextSpan(
                                          text: 'Oficina de Medios Digitales- OMD\n',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).primaryColor)
                                      ),
                                      TextSpan(
                                          text: 'mediosdigitales@unal.edu.co',
                                          style:
                                          Theme.of(context).textTheme.bodySmall
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent

                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Dirección Oficina de Medios Digitales: \n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor)),
                                      TextSpan(
                                          text: 'Martha Lucia Chaves Muñoz\n',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).primaryColor)
                                      ),
                                      TextSpan(
                                          text: 'mlchavezm@unal.edu.co',
                                          style:
                                          Theme.of(context).textTheme.bodySmall
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent

                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Ingeniero de Desarrollo: \n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor)),
                                      TextSpan(
                                          text: 'Miguel AndresTorres Chavarro\n',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).primaryColor)
                                      ),
                                      TextSpan(
                                          text: 'miatorresch@unal.edu.co',
                                          style:
                                          Theme.of(context).textTheme.bodySmall
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("• "),
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent

                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Diseño gráfico de interfaz: \n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor)),
                                      TextSpan(
                                          text: 'Maria Teresa Naranjo Castillo\n',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context).primaryColor)
                                      ),
                                      TextSpan(
                                          text: 'mtnaranjoc@unal.edu.co',
                                          style:
                                          Theme.of(context).textTheme.bodySmall
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      margin: const EdgeInsets.only(top: 20),
                    )
                  ]),
            )));
  }
}
