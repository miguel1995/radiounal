import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastSeriesBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchSeries(int page) async {
    Map<String, dynamic> map = await _repository.findSeries(page);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}