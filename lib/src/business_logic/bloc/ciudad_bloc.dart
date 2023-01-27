import 'package:rxdart/rxdart.dart';
import '../../data/models/countriesNow/ciudad_model.dart';
import '../../data/repositories/countriesnow_repository.dart';

class CiudadBloc{

  final _repository = CountriesNowRepository();
  final _subject = BehaviorSubject<List<CiudadModel>>();

  fetchCiudades(String pais, String departamento) async {
    List<CiudadModel> modelList = await _repository.findCiudades(pais, departamento);
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<CiudadModel>> get subject => _subject;
}