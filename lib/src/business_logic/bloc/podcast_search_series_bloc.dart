import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repositories/podcast_repository.dart';

class PodcastSearchSeriesBloc{


  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchSearch(String query, int page, String contentType) async {
    Map<String, dynamic> map = await _repository.findSearch(query, page, contentType);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<dynamic> get subject => _subject;}