import 'package:rxdart/rxdart.dart';

class IsSeguidoBloc{

  final _subject = BehaviorSubject<bool>();

  setIsSeguido(bool value) async {
    _subject.sink.add(value);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<bool> get subject => _subject;
}