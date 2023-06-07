import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarRadio extends StatelessWidget implements PreferredSizeWidget {

  get vgPicture => null;
  late bool enableBack;
  AppBarRadio({Key? key, required bool this.enableBack}) : super(key: key);


  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        leading: (enableBack)?IconButton(
          icon:  const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () =>  Navigator.pop(context)
        ):null,
        title: Container(
            child:
            InkWell(
              onTap: (){
                //Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

              },
              child:SvgPicture.asset(
                  "assets/icons/identificador_radioUNAL.svg",
                  width: MediaQuery.of(context).size.width * 0.40)
            ),
            ),
        centerTitle: true,

        actions: <Widget>[
          InkWell(
              onTap: () {
                //Navigator.popUntil(context, ModalRoute.withName('/'));
                //Navigator.of(context).pop();
                Navigator.pushNamed(context, '/browser');
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child:
                      SvgPicture.asset('assets/icons/icono_lupa_buscador.svg',
                        width: 25,

                      ))),
          InkWell(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.more_vert,
                    color: Theme.of(context).appBarTheme.foregroundColor
                  )
              )
          )
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
