import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioDescargaBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<String>();

  addDescarga(
  String nombre,
  String edad,
  String genero,
  String pais,
  String departamento,
  String ciudad,
  String email) async {
    String str = await _repository.createDescarga(
        nombre,
        edad,
        genero,
        pais,
        departamento,
        ciudad,
        email
    );
    _subject.sink.add(str);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<String> get subject => _subject;
}