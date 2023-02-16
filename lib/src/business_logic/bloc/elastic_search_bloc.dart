import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repositories/elasticsearch_repository.dart';

class ElasticSearchBloc{

  final _repository = ElasticSearchRepository();
  final _subject = BehaviorSubject<dynamic>();

  fetchSearch(
      String query,
      int from,
      int size
  ) async {

    Map<String, dynamic> map = await _repository.findSearch(
      query,
      from,
      size,
    );
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<dynamic> get subject => _subject;}