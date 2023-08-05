import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarRadio extends StatefulWidget implements PreferredSizeWidget {
  late bool enableBack;
  AppBarRadio({Key? key, required bool this.enableBack}) : super(key: key);

  @override
  State<AppBarRadio> createState() => _AppBarRadioState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarRadioState extends State<AppBarRadio> {
  get vgPicture => null;
  bool isDarkMode = false;
  @override
  void initState() {print('=====================app_bar_radio');
     themeMethod().then((value) {
      setState(() {
        
      isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });
  }

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  Widget build(BuildContext context) {



    
    themeMethod().then((value) {
      setState(() {
        
      isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });
    return AppBar(
        backgroundColor: isDarkMode ? Color(0x00000000) : Color(0xff121C4A),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        leading: (widget.enableBack)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    color: Color(0xFFFCDC4D)),
                onPressed: () => Navigator.pop(context))
            : null,
        title: Container(
          child: InkWell(
              onTap: () {
                //Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              child: SvgPicture.asset(
                  "assets/icons/identificador_radioUNAL.svg",
                  color: Color(0xFFFCDC4D))),
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
                  child: SvgPicture.asset(
                    'assets/icons/icono_lupa_buscador.svg',
                    width: 25,
                    color: Color(0xFFFCDC4D),
                  ))),
          InkWell(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.more_vert, color: Color(0xFFFCDC4D))))
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
