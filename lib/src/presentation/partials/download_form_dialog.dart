import 'dart:collection';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../business_logic/bloc/ciudad_bloc.dart';
import '../../business_logic/bloc/departamento_bloc.dart';
import '../../business_logic/bloc/pais_bloc.dart';
import '../../business_logic/bloc/radio_descarga_bloc.dart';

class DownloadFormDialog extends StatefulWidget {
  final Function(bool status) callBackFormDialog;

  const DownloadFormDialog(this.callBackFormDialog, {super.key});

  @override
  _DownloadFormDialogState createState() => _DownloadFormDialogState();
}

class _DownloadFormDialogState extends State<DownloadFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool flagPolitics = false;
  Map<String, String> list = {"masculino": "masculino", "femenino": "femenino"};
  String? dropdownValue = "";

  Map<String, String> listPais =
      SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValuePais = "";
  Map<String, String> listDepartamentos =
      SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueDepartamento = "";
  Map<String, String> listCiudades =
      SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueCiudad = "";

  String nombre = "";
  String edad = "";
  String pais = "";
  String departamento = "";
  String ciudad = "";
  String email = "";
  String genero = "masculino";

  final blocPais = PaisBloc();
  final blocDepartamento = DepartamentoBloc();
  final blocCiudad = CiudadBloc();
  final blocRadioDescarga = RadioDescargaBloc();

  late SharedPreferences prefs;
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerEdad = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
 bool isDarkMode =false;
Future<AdaptiveThemeMode?> themeMethod() async {
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
return savedThemeMode;
}
  @override
  void initState() { 
    var brightness = SchedulerBinding.instance.window.platformBrightness;
 isDarkMode = brightness == Brightness.dark;
    initializePreference();

    blocPais.fetchPaises();
    blocPais.subject.stream.listen((value) {
      if (value != null && value.length > 0) {
        for (var e in value) {
          listPais[e.name] = e.name;
        }

        setState(() {
          listPais = listPais;
          pais = ((pais == "") ? listPais["Colombia"] : pais)!;
          dropdownValuePais = pais;
        });

        updateDepartments(pais, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {


                themeMethod().then((value) {
          setState(() {
            
     isDarkMode=value==AdaptiveThemeMode.dark;
          });
    });
    return AlertDialog(
        insetPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        content: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => {Navigator.pop(context)},
                        child: Icon(Icons.close,
                            size: 30,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor),
                      )),
                   Text(
                    "Formulario de descarga",
                    style: TextStyle(
                      shadows: [
                        Shadow(color:isDarkMode? Color(0xFF121C4A):Color(0xFFFFFFFF), offset: Offset(0, -5))
                      ],
                      color: Colors.transparent,
                      decorationThickness: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(isDarkMode?0xff121C4A:0xFFFCDC4D),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Nombre*",
                        style: getTextStyle(isDarkMode),
                      )),
                  TextFormField(

                      controller: _controllerNombre,
                      decoration:
                          getFieldDecoration("Ingrese sus Nombres y Apellidos"),
                      style: const TextStyle(
                        color: Color(0xFF121C4A),
                        
                        decoration: TextDecoration.none),
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
                        prefs.setString('nombre', nombre);
                      }),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Edad*",
                        style: getTextStyle(isDarkMode),
                      )),
                  TextFormField(
                      controller: _controllerEdad,
                      keyboardType: TextInputType.number,
                      decoration: getFieldDecoration("Edad"),
                      style: const TextStyle( color: Color(0xFF121C4A),decoration: TextDecoration.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un texto';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          edad = value.toString();
                        });
                        prefs.setString('edad', edad);
                      }),
                  /*Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Text("Género*",
                            style: getTextStyle(),
                          )),*/
                  /*Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              genero = value!;
                            });
                            prefs.setString('genero', genero);
                          },
                          items:
                          list.keys.map<DropdownMenuItem<String>>((String value) {

                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(list[value]!),
                            );
                          }).toList(),
                        ),
                      ),*/
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "País*",
                        style: getTextStyle(isDarkMode),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: dropdownValuePais,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValuePais = value;
                          pais = value!;
                        });
                        prefs.setString('pais', pais);
                        updateDepartments(pais, false);
                      },
                      items: (listPais.length > 0)
                          ? listPais.keys
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 9),
                                      child: Text(listPais[value]!
                                      ,style: TextStyle( color: Color(0xFF121C4A),),
                                      
                                      )
                                      
                                      
                                      ));
                            }).toList()
                          : [],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Departamento*",
                        style: getTextStyle(isDarkMode),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: dropdownValueDepartamento,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueDepartamento = value;
                          departamento = value!;
                        });
                        prefs.setString('departamento', departamento);
                        updateCities(pais, departamento, false);
                      },
                      items: (listDepartamentos.isNotEmpty)
                          ? listDepartamentos.keys
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 9),
                                      child: Text(listDepartamentos[value]!
                                          .replaceAll("Department", "")
                                          ,style: TextStyle( color: Color(0xFF121C4A),),
                                          )));
                            }).toList()
                          : [],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Ciudad*",
                        style: getTextStyle(isDarkMode),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: dropdownValueCiudad,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueCiudad = value;
                          ciudad = value!;
                        });
                        prefs.setString('ciudad', ciudad);
                      },
                      items: (listCiudades.isNotEmpty)
                          ? listCiudades.keys
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 9),
                                      child: Text(listCiudades[value]!,
                                      style: TextStyle( color: Color(0xFF121C4A),),
                                      
                                      )));
                            }).toList()
                          : [],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child:
                          Text("Correo Electrónico*", style: getTextStyle(isDarkMode))),
                  TextFormField(
                      controller: _controllerEmail,
                      decoration:
                          getFieldDecoration("Ingrese su correo electrónico"),
                          style: TextStyle( color: Color(0xFF121C4A),),
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
                        prefs.setString('email', email);
                      }),
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
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: InkWell(
                              onTap: () {
                                _launchURL(
                                    "https://unal.edu.co/fileadmin/user_upload/docs/ProteccionDatos/Resolucion-207_2021-Rectoria.pdf");
                              },
                              child:  Text(
                                  "Política de tratamiento de datos personales*",
                                  style: TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                                          offset: const Offset(0, -5))
                                    ],
                                    color: Colors.transparent,
                                    decorationThickness: 1,
                                    decorationColor:  isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                      Checkbox(
                          checkColor: Color(0xFF121C4A),
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
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
                  Text(
                    "DE ACUERDO CON LA LEY 1581 DE 2012 DE PROTECCIÓN DE DATOS PERSONALES, HE LEÍDO Y ACEPTO LOS TERMINOS DESCRITOS EN LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
                    style: getTextStyle(isDarkMode),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: RadialGradient(
                              radius: 0.8,
                              colors: [
                               isDarkMode? Color(0xff216278):Color(0xffFEE781), 
                               isDarkMode? Color(0xFF121C4A):Color(0xffFFCC17)
                               ]),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor),
                          onPressed: () {
                            //Validate returns true if the form is valid, or false otherwise.
                            if (isChecked == false) {
                              setState(() {
                                flagPolitics = true;
                              });
                            }
                            if (_formKey.currentState!.validate() &&
                                isChecked) {
                              blocRadioDescarga.addDescarga(nombre, edad,
                                  genero, pais, departamento, ciudad, email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Enviando mensaje ...")));
                              blocRadioDescarga.subject.stream.listen((event) {
                                /*ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(event.toString())),
                                  );*/
                                //Inicia la Descarga del archivo .mp3
                                widget.callBackFormDialog(true);
                                //Navigator.of(context).pop();
                                Navigator.pop(context);

                              });
                            }
                          },
                          child: Text(
                            'Enviar',
                            style: TextStyle(
                                color: isDarkMode?Color(0xFFFFFFFF): Color(0xFF121C4A),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.only(left: 10, right: 5, top: 9, bottom: 9),
      hintText: hintText,
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
      ),
    );
  }

  TextStyle getTextStyle(bool isDarkMode) {
    return  TextStyle(
        color:isDarkMode? Color(0xFF121C4A):Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.bold);
  }

  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.white;
  }

  void updateDepartments(String pais, bool isFirstLoad) {
    blocDepartamento.fetchDepartamentos(pais);
    blocDepartamento.subject.stream.listen((value) {
      if (value != null && value.length > 0) {
        listDepartamentos = {};
        for (var e in value) {
          listDepartamentos[e.name] = e.name;
        }

        setState(() {
          listDepartamentos = listDepartamentos;
          departamento =
              (isFirstLoad) ? departamento : listDepartamentos[value[0].name]!;
          dropdownValueDepartamento = departamento;
        });

        updateCities(pais, departamento, isFirstLoad);
      }
    });
  }

  void updateCities(String pais, String departamento, bool isFirstLoad) {
    blocCiudad.fetchCiudades(pais, departamento);
    blocCiudad.subject.stream.listen((value) {
      if (value != null && value.length > 0) {
        listCiudades = {};

        for (var e in value) {
          listCiudades[e.name] = e.name;
        }

        setState(() {
          listCiudades = listCiudades;
          ciudad =
              (isFirstLoad == true) ? ciudad : listCiudades[value[0].name]!;
          dropdownValueCiudad = ciudad;
        });
      }
    });
  }

  initializePreference() async {
    // obtain shared preferences
    prefs = await SharedPreferences.getInstance();
    setState(() {
      /**Actualiza variables de estado*/
      nombre = prefs.getString('nombre') ?? "";
      edad = prefs.getString('edad') ?? "";
      genero = prefs.getString('genero') ?? "masculino";
      pais = prefs.getString('pais') ?? "Colombia";
      departamento =
          prefs.getString('departamento') ?? "Cundinamarca Department";
      ciudad = prefs.getString('ciudad') ?? "Bogota";
      email = prefs.getString('email') ?? "";

      /**Actualiza los valores de los dropdown del formulario*/
      dropdownValue = genero;
      dropdownValuePais = pais;
      dropdownValueDepartamento = departamento;
      dropdownValueCiudad = ciudad;
    });

    _controllerNombre.text = nombre;
    _controllerEdad.text = edad;
    _controllerEmail.text = email;
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
