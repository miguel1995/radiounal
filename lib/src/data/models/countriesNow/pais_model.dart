class PaisModel{


  late String _name;


  PaisModel(this._name);


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  //Retorna  un EmisionModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de radio desde los providers
  PaisModel.fromJson(Map<String, dynamic> parsedJson) {
    _name = parsedJson["name"];
  }
}