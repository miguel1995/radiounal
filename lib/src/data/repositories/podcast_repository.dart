import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:radiounal/src/data/providers/podcast_provider.dart';

class PodcastRepository {
  final podcastProvider = PodcastProvider();

  Future<List<EpisodioModel>> findDestacados() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EpisodioModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await podcastProvider.getDestacados();

    }

    return temp;
  }

  Future<List<EpisodioModel>> findMasEscuchados() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EpisodioModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await podcastProvider.getMasEscuchados();

    }

    return temp;
  }


  Future<Map<String, dynamic>> findSeries(int page) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await podcastProvider.getSeries(page);

    }

    return temp;
  }


  Future<Map<String, dynamic>> findEpisodios(int uid, int page) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await podcastProvider.getEpisodios(uid, page);

    }

    return temp;
  }


  Future<List<EpisodioModel>> findEpisodio(int uid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EpisodioModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await podcastProvider.getEpisodio(uid);

    }

    return temp;
  }

  Future<Map<String, dynamic>> findSeriesYEpisodios(List<int> seriesUidList, List<int> episodiosUidList) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await podcastProvider.getSeriesYEpisodios(seriesUidList, episodiosUidList);

    }

    return temp;
  }



}
