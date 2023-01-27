import 'dart:collection';

import 'package:flutter/material.dart';
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
  String? dropdownValue = "masculino";

  Map<String, String> listPais = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValuePais = "";
  Map<String, String> listDepartamentos = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueDepartamento = "Cundinamarca Department";
  Map<String, String> listCiudades = SplayTreeMap<String, String>((a, b) => a.compareTo(b));
  String? dropdownValueCiudad= "";

  String nombre =  "";
  String edad =  "";
  String pais =  "";
  String departamento ="";
  String ciudad = "";
  String email = "";
  String genero = "";

  final blocPais = PaisBloc();
  final blocDepartamento = DepartamentoBloc();
  final blocCiudad = CiudadBloc();
  final blocRadioDescarga = RadioDescargaBloc();

  @override
  void initState() {
    blocPais.fetchPaises();
    blocPais.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        for (var e in value) {
          listPais[e.name] = e.name;
        }

        setState(() {
          listPais = listPais;
          dropdownValuePais = listPais["Colombia"];
          pais = listPais["Colombia"]!;
        });

        updateDepartments(pais);
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
                        decoration:
                        getFieldDecoration("Ingrese sus Nombres y Apellidos"),
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
                          }
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child:  Text("Edad*",
                            style: getTextStyle(),
                          )),
                      TextFormField(
                          keyboardType: TextInputType.number,
                        decoration: getFieldDecoration("Edad"),
                        style: TextStyle(decoration: TextDecoration.none),
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
                            updateDepartments(pais);
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
                              updateCities(pais, departamento);
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
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).appBarTheme.foregroundColor),
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
                      )
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

  void updateDepartments(String pais){
    blocDepartamento.fetchDepartamentos(pais);
    blocDepartamento.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        listDepartamentos = {};
        for (var e in value) {

          listDepartamentos[e.name] = e.name;
        }


        setState(() {
          listDepartamentos = listDepartamentos;
          dropdownValueDepartamento = listDepartamentos[value[0].name];
          departamento = listDepartamentos[value[0].name]!;

        });

        updateCities(pais, departamento);

      }
    });
  }

  void updateCities(pais, departamento){
    blocCiudad.fetchCiudades(pais, departamento);
    blocCiudad.subject.stream.listen((value) {
      if(value != null && value.length > 0){

        listCiudades = {};

        for (var e in value) {
          listCiudades[e.name] = e.name;
        }

        setState(() {
          listCiudades = listCiudades;
          dropdownValueCiudad = listCiudades[value[0].name];
          ciudad = listCiudades[value[0].name]!;
        });
      }
    });

  }

}