class InfoModel {
  late int _count =  0;
  late int _pages =  0;
  late String _next =  "";
  late String _prev =  "";

  InfoModel(this._count, this._pages, this._next, this._prev);

  String get prev => _prev;

  set prev(String value) {
    _prev = value;
  }

  String get next => _next;

  set next(String value) {
    _next = value;
  }

  int get pages => _pages;

  set pages(int value) {
    _pages = value;
  }

  int get count => _count;

  set count(int value) {
    _count = value;
  }

  //Retorna  un InfoModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de podcast desde los providers
  InfoModel.fromJson(Map<String, dynamic> parsedJson) {

    _count = parsedJson["count"]??0;
    _pages = parsedJson["pages"]??0;
    _next = (parsedJson["next"]!=null)?parsedJson["next"].toString():"";
    _prev = (parsedJson["prev"]!=null)?parsedJson["prev"].toString():"";

  }
}