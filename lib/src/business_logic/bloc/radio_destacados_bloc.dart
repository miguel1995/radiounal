

import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioDestacadosBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<List<EmisionModel>>();

  fetchDestacados() async {
    List<EmisionModel> modelList = await _repository.findDestacados();
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EmisionModel>> get subject => _subject;
}