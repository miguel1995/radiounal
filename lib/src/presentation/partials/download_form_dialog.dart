import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/bloc/ciudad_bloc.dart';
import '../../business_logic/bloc/departamento_bloc.dart';
import '../../business_logic/bloc/pais_bloc.dart';
import '../../business_logic/bloc/radio_descarga_bloc.dart';



class DownloadFormDialog extends StatefulWidget {

  final Function(bool status)  callBackFormDialog;


  const DownloadFormDialog(this.callBackFormDialog, {super.key});

  @override
  _DownloadFormDialogState createState() => _DownloadFormDialogState();
}

class _DownloadFormDialogState extends State<DownloadFormDialog> {

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool flagPolitics = false;
  Map<String, String> list = {
    "masculino": "masculino",
    "femenino": "femenino"
  };
  String? dropdownValue = "";

  Map<String, String> listPais = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValuePais = "";
  Map<String, String> listDepartamentos = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueDepartamento = "";
  Map<String, String> listCiudades = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueCiudad= "";

  String nombre =  "";
  String edad =  "";
  String pais =  "";
  String departamento ="";
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

  @override
  void initState() {

    initializePreference();

    blocPais.fetchPaises();
    blocPais.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        for (var e in value) {
          listPais[e.name] = e.name;
        }

        setState(() {
          listPais = listPais;
          pais = ((pais =="")?listPais["Colombia"]:pais)!;
          dropdownValuePais = pais;
        });

        updateDepartments(pais, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Text(
            "Formulario de descarga",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decorationColor: Color(0xFFFCDC4D),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child:
          Container(
            child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child:  Text("Nombre*",
                            style: getTextStyle(),
                          )),
                      TextFormField(
                        controller: _controllerNombre,
                        decoration: getFieldDecoration("Ingrese sus Nombres y Apellidos"),
                        style: const TextStyle(decoration: TextDecoration.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un texto';
                          }
                          return null;
                        },
                          onChanged: (value){
                            setState(() {
                              nombre = value;
                            });
                            prefs.setString('nombre', nombre);
                          }
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child:  Text("Edad*",
                            style: getTextStyle(),
                          )),
                      TextFormField(
                        controller: _controllerEdad,
                          keyboardType: TextInputType.number,
                        decoration: getFieldDecoration("Edad"),
                        style: const TextStyle(decoration: TextDecoration.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un texto';
                          }
                          return null;
                        },
                          onChanged: (value){
                            setState(() {
                              edad = value.toString();
                            });
                            prefs.setString('edad', edad);
                          }
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Text("Género*",
                            style: getTextStyle(),
                          )),
                      Container(
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
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Text("País*",
                            style: getTextStyle(),
                          )),
                      Container(
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
                          items:
                          (listPais.length>0)?listPais.keys.map<DropdownMenuItem<String>>((String value) {

                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(listPais[value]!)
                            );
                          }).toList():[],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Text("Departamento*",
                            style: getTextStyle(),
                          )),
                      Container(
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
                          items:
                          (listDepartamentos.isNotEmpty)?listDepartamentos.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(listDepartamentos[value]!.replaceAll("Department", ""))
                            );
                          }).toList():[],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Text("Ciudad*",
                            style: getTextStyle(),
                          )),
                      Container(
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
                          items:
                          (listCiudades.isNotEmpty)?listCiudades.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(listCiudades[value]!)
                            );
                          }).toList():[],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("Correo Electrónico*",
                              style: getTextStyle()
                          )),
                      TextFormField(
                        controller: _controllerEmail,
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
                            prefs.setString('email', email);
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

                          Flexible(child:Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: const Text("Política de tratamiento de datos personales*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )),
                          Checkbox(
                              checkColor: Theme.of(context).primaryColor,
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
                      Text(
                        "DE ACUERDO CON LA LEY 1581 DE 2012 DE PROTECCIÓN DE DATOS PERSONALES, HE LEÍDO Y ACEPTO LOS TERMINOS DESCRITOS EN LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
                        style: getTextStyle(),

                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child:
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: RadialGradient(
                                radius: 0.8,
                                colors: [

                                  Color(0xffFCDC4D),
                                  Color(0xffFFCC17 )
                            ]),

                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
                          onPressed: () {
                            //Validate returns true if the form is valid, or false otherwise.
                            if (isChecked == false) {
                              setState(() {
                                flagPolitics = true;
                              });
                            }
                            if (_formKey.currentState!.validate() && isChecked) {

                              blocRadioDescarga.addDescarga(nombre, edad, genero, pais, departamento, ciudad, email);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Enviando mensaje ..."))
                                );
                                blocRadioDescarga.subject.stream.listen((event) {
                                  /*ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(event.toString())),
                                  );*/
                                  //Inicia la Descarga del archivo .mp3
                                  widget.callBackFormDialog(true);
                                  Navigator.of(context).pop();
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
                      ))
                    ],
                  ),
                )),
          ),
        )
    );
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.white,

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
      ),


    );
  }


  TextStyle getTextStyle() {
    return const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold);
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

  void updateDepartments(String pais, bool isFirstLoad){
    blocDepartamento.fetchDepartamentos(pais);
    blocDepartamento.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        listDepartamentos = {};
        for (var e in value) {

          listDepartamentos[e.name] = e.name;
        }


        setState(() {
          listDepartamentos = listDepartamentos;
          departamento = (isFirstLoad)?departamento:listDepartamentos[value[0].name]!;
          dropdownValueDepartamento = departamento;

        });

        updateCities(pais, departamento, isFirstLoad);

      }
    });
  }

  void updateCities(String pais, String departamento, bool isFirstLoad){
    blocCiudad.fetchCiudades(pais, departamento);
    blocCiudad.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        listCiudades = {};

        for (var e in value) {
          listCiudades[e.name] = e.name;
        }

        setState(() {
          listCiudades = listCiudades;
          ciudad = (isFirstLoad==true)?ciudad:listCiudades[value[0].name]!;
          dropdownValueCiudad = ciudad;
        });
      }
    });

  }

  initializePreference() async{
    // obtain shared preferences
    prefs = await SharedPreferences.getInstance();
    setState(() {
      /**Actualiza variables de estado*/
        nombre = prefs.getString('nombre') ?? "";
        edad = prefs.getString('edad') ?? "";
        genero = prefs.getString('genero') ?? "masculino";
        pais = prefs.getString('pais') ?? "Colombia";
        departamento = prefs.getString('departamento') ?? "Cundinamarca Department";
        ciudad = prefs.getString('ciudad') ?? "Bogota";
        email = prefs.getString('email') ?? "";

        /**Actualiza los valores de los dropdown del formulario*/
        dropdownValue = genero;
        dropdownValuePais = pais;
        dropdownValueDepartamento = departamento;
        dropdownValueCiudad = ciudad;
      }
    );

    _controllerNombre.text = nombre;
    _controllerEdad.text = edad;
    _controllerEmail.text = email;

  }
}