import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

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
  String? dropdownValue = "TIPO1";





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  "Contáctenos",
                  style: TextStyle(
                    color: Color(0xff121C4A),
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
                  child: const Text("Tipo de contacto*")),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 40,
                  ),
                  underline: Container(
                    color: Colors.white,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                      tipo = value!;
                      });
                    },
                  items:
                      list.keys.map<DropdownMenuItem<String>>((String value) {

                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(list[value]!),
                    );
                  }).toList(),
                ),
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
                child: Text(
                    "Para peticiones, quejas, reclamos, sugerecias y felicitaciones haz click aquí",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text("Política de tratamiento de datos personales*",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
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
                  style: TextStyle(color: Colors.red),
                ),
              const Text(
                  "DE ACUERDO CON LA LEY 1581 DE 2012 DE PROTECCIÓN DE DATOS PERSONALES, HE LEÍDO Y ACEPTO LOS TERMINOS DESCRITOS EN LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES"),
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

                      blocRadioEmail.fetchEmail(nombre, email, telefono, tipo, mensaje);
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
      //bottomNavigationBar: BottomNavigationBarRadio(),
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
}
