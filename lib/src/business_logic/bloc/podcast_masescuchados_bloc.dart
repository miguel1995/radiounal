

import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/repositories/podcast_repository.dart';
import 'package:rxdart/rxdart.dart';

class PodcastMasEscuchadosBloc{

  final _repository = PodcastRepository();
  final _subject = BehaviorSubject<List<EpisodioModel>>();

  fetchMasEscuchados() async {
    List<EpisodioModel> modelList = await _repository.findMasEscuchados();
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<EpisodioModel>> get subject => _subject;
}