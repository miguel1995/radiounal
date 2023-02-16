import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarRadio extends StatelessWidget with PreferredSizeWidget {
  const AppBarRadio({Key? key}) : super(key: key);

  get vgPicture => null;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        title: Center(
            child: SvgPicture.asset(
                "assets/icons/identificador_radioUNAL.svg",
                width: MediaQuery.of(context).size.width * 0.40)),

        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/browser');
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child:
                      SvgPicture.asset('assets/icons/icono_lupa_buscador.svg')))
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
