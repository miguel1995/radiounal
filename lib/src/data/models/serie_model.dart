class SerieModel {
  int _uid;
  String _title;
  String _imagen;
  String _url;

  SerieModel(this._uid, this._title, this._imagen, this._url);

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get imagen => _imagen;

  set imagen(String value) {
    _imagen = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get uid => _uid;

  set uid(int value) {
    _uid = value;
  }
}