
class ScreenArguments {
  final String title;
  final String message;
  final int number;
  final dynamic element;
  String from;
  int numColumnas;

  ScreenArguments(this.title, this.message, this.number, {this.element, this.from = "", this.numColumnas=0});
}