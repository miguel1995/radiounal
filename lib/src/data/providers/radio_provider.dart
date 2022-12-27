import 'dart:convert';
import 'package:radiounal/src/data/models/emisiones_model.dart';
import 'package:http/http.dart' as http;
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';

class RadioProvider {
  final _hostDomain = "radio.unal.edu.co/";
  final _urlDestacados = "rest/noticias/app/destacados/";
  final _urlProgramacion = "rest/noticias/app/programacion";

  List<EmisionModel> parseEmisiones(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<EmisionModel>((json) => EmisionModel.fromJson(json))
        .toList();
  }

  List<ProgramacionModel> parseProgramacion(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<ProgramacionModel>((json) => ProgramacionModel.fromJson(json))
        .toList();
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/destacados/
  Future<List<EmisionModel>> getDestacados() async {
    var url = Uri.parse('http://$_hostDomain$_urlDestacados');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseEmisiones(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }


  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/programacion
  Future<List<ProgramacionModel>> getProgramacion() async {
    var url = Uri.parse('http://$_hostDomain$_urlProgramacion');
    print(url);

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseProgramacion(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

}
