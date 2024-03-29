import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    "TIPO1": "Producción, emisión, evaluación y gestión de documentos radiofónicos",
    "TIPO3": "Solicitudes de contacto telefónico, personal o ubicación",
    "TIPO2": "Otros"
  };

  String nombre =  "";
  String email =  "";
  String telefono =  "";
  String tipo =  "";
  String mensaje =  "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: Menu(),
      appBar:  AppBarRadio(enableBack:true),
      body:
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10 + 80, bottom: 10),
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
                    decorationColor: Color(0xFFFCDC4D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: const Text("Nombre*")),
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
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: const Text("Correo Electrónico*")),
              TextFormField(
                decoration: getFieldDecoration("Ingrese su correo electrónico"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un texto';
                  }
                  return null;
                },
                onChanged: (value){
                  setState(() {
                    email = value;
                  });
                }
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text("Número de contacto")),
              TextFormField(
                decoration: getFieldDecoration("Ingrese su número de contacto"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
                  onChanged: (value){
                    setState(() {
                      telefono = value.toString();
                    });
                  }
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text("Mensaje*")),
              TextFormField(
                decoration: getFieldDecoration("Escriba su mensaje"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un texto';
                  }
                  return null;
                },
                  onChanged: (value){
                    setState(() {
                      mensaje = value;
                    });
                  }
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child:

                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text:"Para peticiones, quejas, reclamos, sugerecias y felicitaciones haz click ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: 'aquí',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = (){
                              _launchURL("https://quejasyreclamos.unal.edu.co/");
                              },

                          ),
                        ])
                )


              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child:
                    InkWell(
                      onTap: (){

                        _launchURL("https://unal.edu.co/fileadmin/user_upload/docs/ProteccionDatos/Resolucion-207_2021-Rectoria.pdf");

                      },
                      child:
                    Text("Política de tratamiento de datos personales*",
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
                  style: TextStyle(color: Colors.red,

                  ),
                ),
              const Text(
                  "DE ACUERDO CON LA LEY 1581 DE 2012 DE PROTECCIÓN DE DATOS PERSONALES, HE LEÍDO Y ACEPTO LOS TERMINOS DESCRITOS EN LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
                  style: TextStyle(
                    fontSize: 12
                  )

              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).appBarTheme.foregroundColor),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (isChecked == false) {
                      setState(() {
                        flagPolitics = true;
                      });
                    }
                    if (_formKey.currentState!.validate() && isChecked) {

                      blocRadioEmail.fetchEmail(nombre, email, telefono, mensaje);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enviando mensaje ..."))
                      );
                      blocRadioEmail.subject.stream.listen((event) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(event.toString())),
                        );
                      });
                    }
                  },
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
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
