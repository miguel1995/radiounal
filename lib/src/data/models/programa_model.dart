

class ProgramaModel{

  late int _uid;
  late String _title;
  late String _imagen;
  late String _url;

  ProgramaModel(this._uid, this._title, this._imagen, this._url);

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


  //Retorna  un EmisionModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de radio desde los providers
  ProgramaModel.fromJson(Map<String, dynamic> parsedJson) {

    _uid = parsedJson["uid"];
    _title = parsedJson["title"];
    _imagen = parsedJson["imagen"];
    _url = parsedJson["url"];
  }



}