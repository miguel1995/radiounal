import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioEmailBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<String>();

  fetchEmail(String nombre, String email, String telefono, String tipo, String mensaje) async {
    String string = await _repository.createEmail(nombre, email, telefono, tipo, mensaje);
    _subject.sink.add(string);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<String> get subject => _subject;
}