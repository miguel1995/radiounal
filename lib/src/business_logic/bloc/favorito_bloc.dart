import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:rxdart/rxdart.dart';

class FavoritoBloc{



  final _subject = BehaviorSubject<bool>();
  FirebaseLogic firebaseLogic = FirebaseLogic();

  validateFavorite(dynamic uid, dynamic _deviceId) async {
    firebaseLogic.validateFavorite(uid, _deviceId);
    firebaseLogic.subjectFavorite.stream.listen((event) {
      _subject.sink.add(event);
    });

  }

  dispose() {
    _subject.close();
    firebaseLogic.subjectFavorite.close();
  }

  BehaviorSubject<bool> get subject => _subject;
}


