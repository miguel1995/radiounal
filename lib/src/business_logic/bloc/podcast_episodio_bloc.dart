import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastEpisodioBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<List<EpisodioModel>>();

  fetchEpisodio(int uid) async {
    List<EpisodioModel> list = await _repository.findEpisodio(uid);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EpisodioModel>> get subject => _subject;
}