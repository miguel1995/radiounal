import 'package:rxdart/rxdart.dart';

import '../../data/models/countriesNow/departamento_model.dart';
import '../../data/repositories/countriesnow_repository.dart';

class DepartamentoBloc{

  final _repository = CountriesNowRepository();
  final _subject = BehaviorSubject<List<DepartamentoModel>>();

  fetchDepartamentos(String pais) async {
    List<DepartamentoModel> modelList = await _repository.findDepartamentos(pais);
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<DepartamentoModel>> get subject => _subject;
}