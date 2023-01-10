
class ScreenArguments {
  final String title;
  final String message;
  final int number;
  final dynamic element;
  String from;

  ScreenArguments(this.title, this.message, this.number, {this.element, this.from = ""});
}