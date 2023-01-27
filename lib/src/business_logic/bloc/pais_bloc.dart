import 'package:rxdart/rxdart.dart';

import '../../data/models/countriesNow/pais_model.dart';
import '../../data/repositories/countriesnow_repository.dart';

class PaisBloc{

  final _repository = CountriesNowRepository();
  final _subject = BehaviorSubject<List<PaisModel>>();

  fetchPaises() async {
    List<PaisModel> modelList = await _repository.findPaises();
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<PaisModel>> get subject => _subject;
}