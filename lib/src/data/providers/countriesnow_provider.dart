import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/countriesNow/ciudad_model.dart';
import '../models/countriesNow/departamento_model.dart';
import '../models/countriesNow/pais_model.dart';

class CountriesNowProvider {

  final _hostDomain = "countriesnow.space/api/v0.1/";
  final _urlPaises = "countries/info";
  final _urlDepartamentos = "countries/states";
  final _urlCiudades = "countries/state/cities";


  List<PaisModel> parsePaises(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["data"]
        .map<PaisModel>((json) => PaisModel.fromJson(json))
        .toList();
  }

  List<DepartamentoModel> parseDepartamentos(String responseBody, String pais) {
    final parsed = json.decode(responseBody);

    return parsed["data"]["states"]
        .map<DepartamentoModel>((json) => DepartamentoModel.fromJson(json))
        .toList();
  }

  List<CiudadModel> parseCiudades(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["data"]
        .map<CiudadModel>((json) => CiudadModel.fromJson(json))
        .toList();
  }


  //https://countriesnow.space/api/v0.1/countries/population/filter
  Future<List<PaisModel>> getPaises() async {
    var url = Uri.parse('https://$_hostDomain$_urlPaises?returns=name');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parsePaises(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }


  //https://countriesnow.space/api/v0.1/countries/states/q?country=Colombia
  Future<List<DepartamentoModel>> getDepartamentos(String pais) async {

    var url = Uri.parse('https://$_hostDomain$_urlDepartamentos/q?country=$pais');
    //print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseDepartamentos(utf8.decode(response.bodyBytes), pais);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //https://countriesnow.space/api/v0.1/countries/states/q?country=Colombia
  Future<List<CiudadModel>> getCiudades(String pais, String departamento) async {

    var url = Uri.parse('https://$_hostDomain${_urlCiudades}/q?country=$pais&state=${departamento}');
    // Await the http get response, then decode the json-formatted response.
    //print(url);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseCiudades(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

}