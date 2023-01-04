

import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioProgramacionBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<List<ProgramacionModel>>();

  fetchProgramacion() async {
    List<ProgramacionModel> modelList = await _repository.findProgramacion();
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<ProgramacionModel>> get subject => _subject;
}