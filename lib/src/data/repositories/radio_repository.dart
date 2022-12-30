import 'package:radiounal/src/data/models/emisiones_model.dart';
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/data/providers/radio_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RadioRepository {
  final radioProvider = RadioProvider();

  Future<List<EmisionModel>> findDestacados() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EmisionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getDestacados();

    }

    return temp;
  }

  Future<List<ProgramacionModel>> findProgramacion() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<ProgramacionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getProgramacion();

    }

    return temp;
  }

  Future<Map<String, dynamic>> findProgramas(int page) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getProgramas(page);

    }

    return temp;
  }
}
