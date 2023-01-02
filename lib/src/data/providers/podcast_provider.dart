import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/data/models/serie_model.dart';

class PodcastProvider {
  final _hostDomain = "podcastradio.unal.edu.co/";
  final _urlDestacados = "rest/noticias/app/destacados/page/1";
  final _urlSeries = "rest/noticias/app/series/page/";
  final _urlEpisodios = "rest/noticias/app/episodiosBySerie";
  final _urlEpisodio = "rest/noticias/app/episodio/";


  List<EpisodioModel> parseEpisodios(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<EpisodioModel>((json) => EpisodioModel.fromJson(json))
        .toList();
  }

  List<SerieModel> parseSeries(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<SerieModel>((json) => SerieModel.fromJson(json))
        .toList();
  }

  InfoModel parseInfo(String responseBody) {
    final parsed = json.decode(responseBody);
    return InfoModel.fromJson(parsed["info"]);
  }

  //consume todos los cintenidos de http://podcastradio.unal.edu.co/rest/noticias/app/destacados/page/1
  Future<List<EpisodioModel>> getDestacados() async {
    var url = Uri.parse('http://$_hostDomain$_urlDestacados');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseEpisodios(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://podcastradio.unal.edu.co/rest/noticias/app/series/page/3
  Future<Map<String, dynamic>> getSeries(int page) async {
    var url = Uri.parse('http://$_hostDomain$_urlSeries${page.toString()}');
    Map<String, dynamic> map = {};
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<SerieModel> result = parseSeries(utf8.decode(response.bodyBytes));
      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));

      map["result"] = result;
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://podcastradio.unal.edu.co/rest/noticias/app/episodiosBySerie
  Future<Map<String, dynamic>> getEpisodios(int uid, int page) async {
    var url = Uri.parse('http://$_hostDomain$_urlEpisodios');
    Map<String, dynamic> map = {};
    var body = jsonEncode(<String, dynamic>{'serie': uid, 'page': page});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      List<EpisodioModel> result = parseEpisodios(utf8.decode(response.bodyBytes));
      InfoModel info = parseInfo(utf8.decode(response.bodyBytes));

      map["result"] = result;
      map["info"] = info;

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  //consume todos los contenidos de http://podcastradio.unal.edu.co/rest/noticias/app/episodio/583
  Future<List<EpisodioModel>> getEpisodio(int uid) async {
    var url = Uri.parse('http://$_hostDomain$_urlEpisodio${uid.toString()}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return parseEpisodios(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
