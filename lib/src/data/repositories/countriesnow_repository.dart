import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:radiounal/src/data/providers/podcast_provider.dart';

import '../models/countriesNow/ciudad_model.dart';
import '../models/countriesNow/departamento_model.dart';
import '../models/countriesNow/pais_model.dart';
import '../providers/countriesnow_provider.dart';


class CountriesNowRepository {

  final countriesNowProvider = CountriesNowProvider();

  Future<List<PaisModel>> findPaises() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<PaisModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
        temp = await countriesNowProvider.getPaises();

    }

    return temp;
  }

  Future<List<DepartamentoModel>> findDepartamentos(String pais) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<DepartamentoModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await countriesNowProvider.getDepartamentos(pais);

    }

    return temp;

  }

  Future<List<CiudadModel>> findCiudades(String pais, String departamento) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<CiudadModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await countriesNowProvider.getCiudades(pais, departamento);

    }

    return temp;

  }

}
