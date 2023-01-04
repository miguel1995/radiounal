import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastSeriesYEpisodiosBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchSeriesYEpisodios(List<int> seriesUidList, List<int> episodiosUidList) async {
    Map<String, dynamic> map = await _repository.findSeriesYEpisodios(seriesUidList, episodiosUidList);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}