class EmisionModel{

  late  int _uid;
  late String _title;
  late String _teaser;
  late String _bodytext;
  late String _date;
  late String _imagen;
  late String _url;
  late String _audio;

  EmisionModel(this._uid, this._title, this._teaser, this._bodytext, this._date,
      this._imagen, this._url, this._audio);

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

  String get bodytext => _bodytext;

  set bodytext(String value) {
    _bodytext = value;
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

  //Retorna  un EmisionModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de radio desde los providers
  EmisionModel.fromJson(Map<String, dynamic> parsedJson) {

    _uid = parsedJson["uid"];
    _title = parsedJson["title"];
    _teaser = parsedJson["teaser"];
    _bodytext = parsedJson["bodytext"];
    _date = parsedJson["date"];
    _imagen = parsedJson["imagen"];
    _url = parsedJson["url"];
    _audio = parsedJson["audio"];


  }
}