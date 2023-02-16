import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioSearchBloc{

  final _repository = RadioRepository();
  final _subject = BehaviorSubject<dynamic>();

  fetchSearch(
  String query,
  int page,
  int sede,
  String canal,
  String area,
  String contentType
  ) async {

    Map<String, dynamic> map = await _repository.findSearch(
        query,
        page,
        sede,
        canal,
        area,
        contentType
    );
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<dynamic> get subject => _subject;}