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
}
