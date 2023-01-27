import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioCalificaBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<String>();

  addEstadistica(
  int itemUid,
  String nombre,
  String sitio,
  String tipo,
  int score,
  String date) async {
    String str = await _repository.createEstadistica(
        itemUid,
        nombre,
        sitio,
        tipo,
        score,
        date
    );
    _subject.sink.add(str);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<String> get subject => _subject;
}