import 'package:radiounal/src/data/models/programa_model.dart';

class ProgramacionModel{
  late String _emisora;
  late String _frecuencia;
  late String _ahoraPrograma;
  late String _ahoraHorario;
  late String _siguientePrograma;
  late String _siguienteHorario;
  late String _masTardePrograma;
  late String _masTardeHorario;

  ProgramacionModel(
      this._emisora,
      this._frecuencia,
      this._ahoraPrograma,
      this._ahoraHorario,
      this._siguientePrograma,
      this._siguienteHorario,
      this._masTardePrograma,
      this._masTardeHorario);

  String get masTardeHorario => _masTardeHorario;

  set masTardeHorario(String value) {
    _masTardeHorario = value;
  }

  String get masTardePrograma => _masTardePrograma;

  set masTardePrograma(String value) {
    _masTardePrograma = value;
  }

  String get siguienteHorario => _siguienteHorario;

  set siguienteHorario(String value) {
    _siguienteHorario = value;
  }

  String get siguientePrograma => _siguientePrograma;

  set siguientePrograma(String value) {
    _siguientePrograma = value;
  }

  String get ahorHorario => _ahoraHorario;

  set ahorHorario(String value) {
    _ahoraHorario = value;
  }

  String get ahorPrograma => _ahoraPrograma;

  set ahorPrograma(String value) {
    _ahoraPrograma = value;
  }

  String get frecuencia => _frecuencia;

  set frecuencia(String value) {
    _frecuencia = value;
  }

  String get emisora => _emisora;

  set emisora(String value) {
    _emisora = value;
  }

  //Retorna  un ProgramaModel a partir de un JSON ingresado
  //Utilizado en el llamado al API de podcast desde los providers
  ProgramacionModel.fromJson(Map<String, dynamic> parsedJson) {

    print(parsedJson);

    _emisora = parsedJson["emisora"] ?? "";
    _frecuencia = parsedJson["frecuencia"] ?? "";
    _ahoraPrograma = parsedJson["ahora"]!=null?(parsedJson["ahora"]["programa"] ?? "") : "";
    _ahoraHorario = parsedJson["ahora"]!=null?(parsedJson["ahora"]["horario"] ?? "") : "";
    _siguientePrograma = parsedJson["siguiente"]!=null?(parsedJson["siguiente"]["programa"] ?? "") : "";
    _siguienteHorario = parsedJson["siguiente"]!=null?(parsedJson["siguiente"]["horario"] ?? "") : "";
    _masTardePrograma = parsedJson["mas_tarde"]!=null?(parsedJson["mas_tarde"]["programa"] ?? "") : "";
    _masTardeHorario = parsedJson["mas_tarde"]!=null?(parsedJson["mas_tarde"]["horario"] ?? "") : "";


  }

}