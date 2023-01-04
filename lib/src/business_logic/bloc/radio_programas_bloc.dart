

import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioProgramasBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchProgramas(int page) async {
    Map<String, dynamic> map = await _repository.findProgramas(page);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}