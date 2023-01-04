import 'package:radiounal/src/data/providers/radio_provider.dart';
import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioProgramasYEmisionesBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchProgramsaYEmisiones(List<int> programasUidList, List<int> emisionesUidList) async {
    Map<String, dynamic> map = await _repository.findProgramasYEmisiones(programasUidList, emisionesUidList);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}