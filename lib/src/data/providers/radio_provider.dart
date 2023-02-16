import 'dart:convert';
import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:http/http.dart' as http;
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';

class RadioProvider {
  final _hostDomain = "radio.unal.edu.co/";
  final _urlDestacados = "rest/noticias/app/destacados/";
  final _urlMasEscuchados = "rest/noticias/app/mas-escuchado/page/1";
  final _urlProgramacion = "rest/noticias/app/programacion";
  final _urlProgramas = "rest/noticias/app/programas/page/";
  final _urlEmisiones = "rest/noticias/app/emisionesByPrograma";
  final _urlEmision = "rest/noticias/app/emision/";
  final _urlProgramasYEmisiones = "rest/noticias/app/programasyemisiones/";
  final _urlContactoEmail = "rest/noticias/app/contacto";
  final _urlEstadistica = "rest/noticias/app/estadistica";
  final _urlDescarga = "rest/noticias/app/descarga";
  final _urlSedes = "rest/noticias/app/sedes";
  final _urlSearch = "rest/noticias/app/search";


  List<EmisionModel> parseEmisiones(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<EmisionModel>((json) => EmisionModel.fromJson(json))
        .toList();
  }

  List<ProgramaModel> parseProgramas(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<ProgramaModel>((json) => ProgramaModel.fromJson(json))
        .toList();
  }

  List<ProgramacionModel> parseProgramacion(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<ProgramacionModel>((json) => ProgramacionModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> parseProgramasyEmisiones(String responseBody) {
    final parsed = json.decode(responseBody);
    Map<String, dynamic> map = {};
    map["programas"] = parsed["results"]["programas"]
        .map<ProgramaModel>((json) => ProgramaModel.fromJson(json))
        .toList();

    map["emisiones"] = parsed["results"]["emisiones"]
        .map<EmisionModel>((json) => EmisionModel.fromJson(json))
        .toList();


    return map;
  }

  InfoModel parseInfo(String responseBody) {
    final parsed = json.decode(responseBody);
    return InfoModel.fromJson(parsed["info"]);
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

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/mas-escuchado/page/1
  Future<List<EmisionModel>> getMasEscuchados() async {
    var url = Uri.parse('http://$_hostDomain$_urlMasEscuchados');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    print(">>> URLLLLLLLLL !!!!");
    print(url);

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

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseProgramacion(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/programas/page/27
  Future<Map<String, dynamic>> getProgramas(int page) async {
    var url = Uri.parse('http://$_hostDomain$_urlProgramas${page.toString()}');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<ProgramaModel> result = parseProgramas(utf8.decode(response.bodyBytes));
      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));

      map["result"] = result;
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/emisionesByPrograma/
  Future<Map<String, dynamic>> getEmisiones(int uid, int page) async {
    var url = Uri.parse('http://$_hostDomain$_urlEmisiones');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(<String, dynamic>{'programa': uid, 'page': page});

    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {

      List<EmisionModel> result = parseEmisiones(utf8.decode(response.bodyBytes));
      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));

      map["result"] = result;
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode} -- ${response.body}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/emision/42969
  Future<List<EmisionModel>> getEmision(int uid) async {
    var url = Uri.parse('http://$_hostDomain$_urlEmision${uid.toString()}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseEmisiones(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/programasyemisiones/
  Future<Map<String, dynamic>> getProgramasYEmisiones(List<int> programasUidList, List<int> emisionesUidList) async {
    var url = Uri.parse('http://$_hostDomain$_urlProgramasYEmisiones');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(<String, dynamic>{'programasUidList': programasUidList, 'emisionesUidList': emisionesUidList});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      map = parseProgramasyEmisiones(utf8.decode(response.bodyBytes));
      return map;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<String> postEmail(String nombre, String email, String telefono, String tipo, String mensaje) async {
    var url = Uri.parse('http://$_hostDomain$_urlContactoEmail');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(<String, dynamic>{
      "nombre":nombre,
      "email":email,
      "telefono":telefono,
      "tipo":tipo,
      "mensaje":mensaje
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {

      final parsed = json.decode(utf8.decode(response.bodyBytes));
      String string = "";

      if(parsed["info"] != null){
        if(parsed["info"]["mensaje"] != null){
          string = parsed["info"]["mensaje"];
        }

      }

      return string;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
  /*
  * itemUid: uid de la serie, programa, episodio o emision
    nombre: nombre del elemento
    sitio: RADIO o PODCAST
    tipo: SERIE, PROGRAMA, EPISODIO o EMISION
    score: int. calificacion de estrellas
    date: "20-01-2023"
  * */
  Future<String> postEstadistica(int itemUid, String nombre, String sitio, String tipo, int score, String date) async {
    var url = Uri.parse('http://$_hostDomain$_urlEstadistica');
    String string = "";
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(<String, dynamic>{
      "itemUid":itemUid,
      "nombre":nombre,
      "sitio":sitio,
      "tipo":tipo,
      "score":score,
      "date":date
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {

      final parsed = json.decode(utf8.decode(response.bodyBytes));

      if(parsed["info"] != null){
        if(parsed["info"]["mensaje"] != null){
          string = parsed["info"]["mensaje"];
        }

      }

      return string;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

  }

  /*
  *
    nombre: nombre del elemento
    edad: string
    genero: masculino o femenino
    pais: string
    ciudad: string
    email: string
  * */

  Future<String> postDescarga(String nombre, String edad, String genero, String pais, String departamento, String ciudad, String email) async {
    var url = Uri.parse('http://$_hostDomain$_urlDescarga');
    String string = "";
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(<String, dynamic>{
      "nombre":nombre,
      "edad":edad,
      "genero":genero,
      "pais":pais,
      "departamento":departamento,
      "ciudad":ciudad,
      "email":email
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {

      final parsed = json.decode(utf8.decode(response.bodyBytes));

      if(parsed["info"] != null){
        if(parsed["info"]["mensaje"] != null){
          string = parsed["info"]["mensaje"];
        }
      }

      return string;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/sedes
  Future<Map<String, dynamic>> getSedes() async {
    var url = Uri.parse('http://$_hostDomain$_urlSedes');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<ProgramaModel> result = parseProgramas(utf8.decode(response.bodyBytes));
      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));

      map["result"] = result;
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/search
  Future<Map<String, dynamic>> getSearch(
      String query,
      int page,
      int sede,
      String canal,
      String area,
      String contentType
      ) async {
    var url = Uri.parse('http://$_hostDomain$_urlSearch');
    Map<String, dynamic> map = {};

    var body = jsonEncode(<String, dynamic>{
      "query":query,
      "page":page,
      "filters":{
        "sede":(sede!=0)?sede:"TODOS",
        "canal":canal,
        "area":area,
        "contentType":contentType
      }
    });

    print(url);
    print(body);

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    List<EmisionModel> resultForEmisiones = [];
    List<ProgramaModel> resultForProgramas = [];
    if (response.statusCode == 200) {
      if(contentType == "EMISIONES") {
         resultForEmisiones = parseEmisiones(
            utf8.decode(response.bodyBytes));
         map["result"] = resultForEmisiones;
      }else if(contentType == "PROGRAMAS"){
          resultForProgramas = parseProgramas(
            utf8.decode(response.bodyBytes));
          map["result"] = resultForProgramas;
      }

      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

}
