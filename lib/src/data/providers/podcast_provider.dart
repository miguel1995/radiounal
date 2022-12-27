import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radiounal/src/data/models/episodio_model.dart';

class PodcastProvider {
  final _hostDomain = "podcastradio.unal.edu.co/";
  final _urlDestacados = "rest/noticias/app/destacados/page/1";


  List<EpisodioModel> parseEpisodios(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed["results"]
        .map<EpisodioModel>((json) => EpisodioModel.fromJson(json))
        .toList();
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
}
