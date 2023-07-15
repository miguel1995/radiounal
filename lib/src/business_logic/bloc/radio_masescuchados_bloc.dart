

import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioMasEscuchadosBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<List<EmisionModel>>();

  fetchMasEscuchados() async {
    List<EmisionModel> modelList = await _repository.findMasEscuchados();

    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EmisionModel>> get subject => _subject;
}