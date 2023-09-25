import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logic/bloc/radio_email_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactsPage> {
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final blocRadioEmail = RadioEmailBloc();

  bool isChecked = false;
  bool flagPolitics = false;
  Map<String, String> list = {
    "TIPO1":
        "Producción, emisión, evaluación y gestión de documentos radiofónicos",
    "TIPO3": "Solicitudes de contacto telefónico, personal o ubicación",
    "TIPO2": "Otros"
  };

  String nombre = "";
  String email = "";
  String telefono = "";
  String tipo = "";
  String mensaje = "";
  bool isDarkMode = false;
  GlobalKey _topKey = GlobalKey(); // Usa una GlobalKey sin tipo específico
  var topPadding = 0.0;

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

    final appBarRenderBox =
        _topKey.currentContext?.findRenderObject() as RenderBox?;
    if (appBarRenderBox != null) {
      topPadding = appBarRenderBox.size.height;
    }

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121C4A) : Color(0xFFFFFFFF),
      extendBodyBehindAppBar: true,
      endDrawer: Menu(),
      appBar: AppBarRadio(key: _topKey, enableBack: true),
      body: Container(
        color: isDarkMode ? const Color(0xFF121C4A) : const Color(0xFFFFFFFF),
        padding:
            EdgeInsets.only(left: 20, right: 20, top: topPadding, bottom: 10),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  "Contáctenos",
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
                    decorationColor: const Color(0xFFFCDC4D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Nombre*",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF121C4A),
                      ))),
              TextFormField(
                  decoration:
                      getFieldDecoration("Ingrese sus Nombres y Apellidos"),
                  style: TextStyle(decoration: TextDecoration.none),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un texto';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      nombre = value;
                    });
                  }),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Correo Electrónico*",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF121C4A),
                      ))),
              TextFormField(
                  decoration:
                      getFieldDecoration("Ingrese su correo electrónico"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un texto';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  }),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text("Número de contacto",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF121C4A),
                      ))),
              TextFormField(
                  decoration:
                      getFieldDecoration("Ingrese su número de contacto"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      telefono = value.toString();
                    });
                  }),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text("Mensaje*",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF121C4A),
                      ))),
              TextFormField(
                  decoration: getFieldDecoration("Escriba su mensaje"),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un texto';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      mensaje = value;
                    });
                  }),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text:
                            "Para peticiones, quejas, reclamos, sugerecias y felicitaciones haz click ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'aquí',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL("https://quejasyreclamos.unal.edu.co/");
                        },
                    ),
                  ]))),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: InkWell(
                        onTap: () {
                          _launchURL(
                              "https://unal.edu.co/fileadmin/user_upload/docs/ProteccionDatos/Resolucion-207_2021-Rectoria.pdf");
                        },
                        child: Text(
                            "Política de tratamiento de datos personales*",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Theme.of(context).primaryColor,
                                    offset: const Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decorationThickness: 1,
                              decorationColor: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                  Checkbox(
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      })
                ],
              ),
              if (flagPolitics == true)
                const Text(
                  "Por favor, acepte las políticas de privacidad",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              Text(
                  "DE ACUERDO CON LA LEY 1581 DE 2012 DE PROTECCIÓN DE DATOS PERSONALES, HE LEÍDO Y ACEPTO LOS TERMINOS DESCRITOS EN LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
                  style: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF121C4A),
                      fontSize: 12)),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFFFCDC4D)),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (isChecked == false) {
                      setState(() {
                        flagPolitics = true;
                      });
                    }
                    if (_formKey.currentState!.validate() && isChecked) {
                      blocRadioEmail.fetchEmail(
                          nombre, email, telefono, mensaje);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Enviando mensaje ...")));
                      blocRadioEmail.subject.stream.listen((event) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(event.toString())),
                        );
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                        color: Color(0xFF121C4A), fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    blocRadioEmail.dispose();
    super.dispose();
  }

  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).appBarTheme.foregroundColor;
    }
    return Theme.of(context).primaryColor;
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 2, color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 2, color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Theme.of(context).primaryColor),
        ));
  }

  TextStyle getTextStyle() {
    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold);
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
