import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastEpisodiosBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<Map<String, dynamic>>();

  fetchEpisodios(int uid, int page) async {
    Map<String, dynamic> map = await _repository.findEpisodios(uid, page);
    _subject.sink.add(map);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Map<String, dynamic>> get subject => _subject;
}