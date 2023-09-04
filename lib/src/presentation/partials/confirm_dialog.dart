
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class ConfirmDialog extends StatefulWidget {
  String tipo;

  ConfirmDialog(this.tipo, {super.key});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  late String tipo;
 bool isDarkMode =false;

  @override
  void initState() { 
    var brightness = SchedulerBinding.instance.window.platformBrightness;
 isDarkMode = brightness == Brightness.dark;
    tipo = widget.tipo;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Color(0xff35395f).withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        content: Column(
            mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.only(bottom: 10), child: getIcon(tipo)),
          Text(
            getText(),
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
        ]));
  }

  String getText() {
    String str = "";
    if (tipo == "FAVORITE") {
      str = 'Agregado a mis\nfavoritos';
    } else if (tipo == "FOLLOWED") {
      str = 'Ahora está siguiendo\neste contenido';
    } else if (tipo == "STATISTIC") {
      str = 'Gracias por calificar\nnuestro contenido';
    }

    return str;
  }

  Widget getIcon(String tipo) {
    Widget widget = Container();
    if (tipo == "FAVORITE") {
      widget = const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      );
    } else if (tipo == "FOLLOWED") {
      widget = Container(
          padding: EdgeInsets.zero,
          child: Image.asset("assets/icons/icono_confirma_siguiendo.png"));
    } else if (tipo == "STATISTIC") {
      widget = Image.asset("assets/icons/icono_confirma_califica.png");
    }
    return widget;
  }
}
