import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioEmisionesBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchEmisiones(int uid, int page) async {
    Map<String, dynamic> map = await _repository.findEmisiones(uid, page);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}