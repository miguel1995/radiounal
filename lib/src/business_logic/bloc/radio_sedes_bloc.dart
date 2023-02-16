import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioSedesBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchSedes() async {
    Map<String, dynamic> map = await _repository.findSedes();
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}