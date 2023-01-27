class DepartamentoModel{

  late String _name;

  DepartamentoModel(this._name);


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  //Utilizado en el llamado al API de radio desde los providers
  DepartamentoModel.fromJson(Map<String, dynamic> parsedJson) {
    _name = parsedJson["name"];
  }
}