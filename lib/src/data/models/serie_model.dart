class SerieModel {
  late int _uid;
  late String _title;
  late String _imagen;
  late String _url;
  late String _description;

  SerieModel(this._uid, this._title, this._imagen, this._url, this._description);

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


  String get description => _description;

  set description(String value) {
    _description = value;
  }

  //Retorna  un SerieModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de podcast desde los providers
  SerieModel.fromJson(Map<String, dynamic> parsedJson) {
    _uid = parsedJson["id"];
    _title = parsedJson["title"];
    _imagen = parsedJson["imagen"];
    _url = parsedJson["url"];
    _description = parsedJson["description"];
  }
}