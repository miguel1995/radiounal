class CiudadModel{


  late String _name;
  CiudadModel(this._name);


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  //Utilizado en el llamado al API de radio desde los providers
  CiudadModel.fromJson(String parsedJson) {
    _name = parsedJson;
  }
}