

class EpisodioModel {

  late int _uid;
  late String _title;
  late String _teaser;
  late String _date;
  late String _imagen;

  late String _url;
  late String _audio;
  late String _pdf;
  late String _categoryTitle;
  late int _categoryUid;
  late String _rss;
  late String _duration;



  EpisodioModel(this._uid, this._title, this._teaser, this._date, this._imagen,
      this._url, this._audio, this._pdf, this._categoryTitle, this._categoryUid, this._rss, this._duration);


  String get pdf => _pdf;

  set pdf(String value) {
    _pdf = value;
  }

  String get audio => _audio;

  set audio(String value) {
    _audio = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get imagen => _imagen;

  set imagen(String value) {
    _imagen = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get teaser => _teaser;

  set teaser(String value) {
    _teaser = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get uid => _uid;

  set uid(int value) {
    _uid = value;
  }

  String get categoryTitle => _categoryTitle;

  set categoryTitle(String value) {
    _categoryTitle = value;
  }


  String get rss => _rss;

  set rss(String value) {
    _rss = value;
  }


  int get categoryUid => _categoryUid;

  set categoryUid(int value) {
    _categoryUid = value;
  }

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }

  //Retorna  un EmisionModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de podcast desde los providers
  EpisodioModel.fromJson(Map<String, dynamic> parsedJson) {

    //print(parsedJson);

    _uid = parsedJson["id"];
    _title = parsedJson["title"]??"";
    _teaser = parsedJson["teaser"]??"";
    _date = parsedJson["date"]??"";
    _imagen = parsedJson["imagen"]??"";
    _url = parsedJson["url"]??"";
    _audio = parsedJson["audio"]??"";
    _pdf = parsedJson["pdf"]??"";
    _rss = parsedJson["rss"]??"";
    _categoryTitle = parsedJson["categoryTitle"]??"";
    _categoryUid = parsedJson["categoryUid"]??0;
    _duration = parsedJson["duration"]??"";

  }
}