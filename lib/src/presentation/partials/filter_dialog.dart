import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:radiounal/src/business_logic/bloc/radio_sedes_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/bloc/ciudad_bloc.dart';
import '../../business_logic/bloc/departamento_bloc.dart';
import '../../business_logic/bloc/pais_bloc.dart';
import '../../business_logic/bloc/radio_descarga_bloc.dart';

class FilterDialog extends StatefulWidget {
  final Function(int sede, String canal, String area) callBackDialog;

  const FilterDialog(this.callBackDialog, {super.key});

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  final _formKey = GlobalKey<FormState>();

  Map<String, String> listCanales = {
    "TODOS": "Todas",
    "BOG": "Bogotá 98.5 fm",
    "MED": "Medellín 100.4 fm",
    "WEB": "Radio Web",
    "POD": "Podcast"
  };
  String? dropdownValueCanales = "TODOS";

  Map<String, String> listAreas = {
    "TODOS": "Todas",
    "TEMATICOS": "Temáticos",
    "ACTUALIDAD": "Actualidad",
    "MUSICALES": "Musicales"
  };
  String? dropdownValueAreas = "TODOS";

  Map<int, String> listSedes = SplayTreeMap<int, String>((a, b) => a.compareTo(b));
  final blocSedes = RadioSedesBloc();
  int? dropdownValueSedes = 0;


  @override
  void initState() {

    blocSedes.fetchSedes();
    blocSedes.subject.stream.listen((value) {
      print(value);

      if (value["result"] != null && value["result"].length > 0) {
        for (var e in value["result"]) {
          listSedes[e.uid] = e.title;
        }
        listSedes[0] = "Todas";

        setState(() {
          listSedes= listSedes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: SingleChildScrollView(
          child: Container(
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => {Navigator.pop(context)},
                        child: const Icon(Icons.close, size: 30),
                      )),
                  Row(children: [
                    InkWell(
                        onTap: () {
                          setState(() {

                            dropdownValueSedes=listSedes.keys.first;
                            dropdownValueCanales="TODOS";
                            dropdownValueAreas="TODOS";

                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              gradient:
                                  const RadialGradient(radius: 1, colors: [
                                Color(0xff1b4564),
                                Color(0xff121C4A),
                              ]),
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff121C4A).withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "Borrar Filtros",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                )
                              ],
                            ))),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.callBackDialog(dropdownValueSedes!, dropdownValueCanales!, dropdownValueAreas!);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            margin: const EdgeInsets.only(left: 50),
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                  radius: 1,
                                  colors: [
                                    Color(0xfffcdf5b),
                                    Color(0xffffcc17)
                                  ]),
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff121C4A).withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "Buscar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                )
                              ],
                            ))),
                  ]),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Sedes",
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
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: dropdownValueSedes,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (int? value) {
                        setState(() {
                          dropdownValueSedes = value;
                        });
                      },
                      items: listSedes.keys
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(listSedes[value]!),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Canales",
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
                      value: dropdownValueCanales,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueCanales = value;
                        });
                      },
                      items: listCanales.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(listCanales[value]!),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Áreas",
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
                      value: dropdownValueAreas,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueAreas = value;
                        });
                      },
                      items: listAreas.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(listAreas[value]!),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            )),
          ),
        ));
  }

  InputDecoration getFieldDecoration(String hintText) {
    return InputDecoration(
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

  TextStyle getTextStyle() {
    return  TextStyle(
        color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold);
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
}
