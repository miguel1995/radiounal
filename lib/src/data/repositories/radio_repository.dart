import 'package:radiounal/src/data/models/emision_model.dart';
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


  Future<Map<String, dynamic>> findEmisiones(int uid, int page) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getEmisiones(uid, page);

    }

    return temp;
  }

  Future<List<EmisionModel>> findEmision(int uid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EmisionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getEmision(uid);

    }

    return temp;
  }

  Future<Map<String, dynamic>> findProgramasYEmisiones(List<int> programasUidList, List<int> emisionesUidList) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getProgramasYEmisiones(programasUidList, emisionesUidList);

    }

    return temp;
  }

  Future<String> createEmail(String nombre, String email, String telefono, String tipo, String mensaje) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    String temp = "";

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.postEmail(nombre, email, telefono, tipo, mensaje);

    }

    return temp;
  }
}
