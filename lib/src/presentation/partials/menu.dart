import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';

class Menu extends StatefulWidget {



  const  Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isHidden = true;

  final List<MenuItem> _menuTitles = [
    MenuItem('Programas Radio UNAL', "/content", "",
        ScreenArguments('SITE', 'RADIO', 1)),
    MenuItem('Series Podcast Radio UNAL', "/content", "",
        ScreenArguments('SITE', 'PODCAST', 1)),
    MenuItem(
        'Favoritos ',
        "/favourites",
        "assets/icons/icono_corazon_blanco.svg",
        ScreenArguments('NONE', 'NONE', 0)
    ),
    MenuItem('Siguiendo', "/followed", "", ScreenArguments('NONE', 'NONE', 1)),
    MenuItem('Configuración', "/configurations", "", null),
    MenuItem('Acerca de esta App', "/configurations", "", null)];

  final List<MenuItem> _menuUrls = [
    MenuItem('UNIMEDIOS  ', "https://unimedios.unal.edu.co/", "assets/icons/icono_links_externos.svg", null),
    MenuItem('Agencia UNAL', "https://agenciadenoticias.unal.edu.co/", "", null),
    MenuItem('Periódico UNAL', "https://periodico.unal.edu.co/", "", null),
    MenuItem('Televisión UNAL ', "https://television.unal.edu.co/", "", null),
    MenuItem("Radio UNAL", "http://radio.unal.edu.co/", "", null),
    MenuItem("Podcast UNAL", "https://podcastradio.unal.edu.co/", "", null),
    MenuItem("Circular UNAL", "http://circular.unal.edu.co/", "", null),
    MenuItem("Orgullo UNAL", "http://orgullo.unal.edu.co/", "", null),
    MenuItem("Debates UNAL", "http://www.debates.unal.edu.co/", "", null),
    MenuItem("Identidad visual", "http://identidad.unal.edu.co/identidad-visual/", "", null),
    MenuItem("Solicitudes Unimedios", "http://solicitudesunimedios.unal.edu.co/", "", null)
  ];




  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(40))),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _buildFlutterLogo(),
                _buildContent(),
              ],
            )));
  }

  Widget _buildFlutterLogo() {
    return Container(
      padding: const EdgeInsets.only( left: 35, top: 60, bottom: 10),
        child: Row(children: [
          Image.asset('assets/images/logo.png',
              width: 150
          ),
      Container(
          margin: EdgeInsets.only(left:60),
          child:IconButton(
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.pop(context);

          },
          icon: const Icon(Icons.close, color: Color(0xffFCDC4D)))),

    ]));
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildListItems(),
        const Divider(
          color: Color(0xffFCDC4D),
          indent: 30,
          endIndent: 30,
        ),
        ..._buildListUrls(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];

    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(GestureDetector(
          onTap: () {
            //Navigator.popUntil(context, ModalRoute.withName("/"));
            //Navigator.of(context).pop();
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

            Navigator.pushNamed(context, _menuTitles[i].url,
                arguments: _menuTitles[i].arguments);
          },
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
              child: Row(
                children: [
                  Text(
                    _menuTitles[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuTitles[i].iconPath != "")
                    SvgPicture.asset(_menuTitles[i].iconPath,
                        //width: MediaQuery.of(context).size.width * 0.05
                   )
                ],
              ))));
    }
    return listItems;
  }

  List<Widget> _buildListUrls() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuUrls.length; ++i) {
      if (i == 0) {
        listItems.add(Row(children: [
          GestureDetector(
            onTap: () {
              _launchURL(_menuUrls[i].url);
            },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
                child: Row(children: [
                  Text(
                    _menuUrls[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuUrls[i].iconPath != "")
                    SvgPicture.asset(_menuUrls[i].iconPath
                        //width: MediaQuery.of(context).size.width * 0.05
                    )
                ])),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ))
        ]));
      } else {
        if (!isHidden) {
          listItems.add(GestureDetector(
            onTap: () {
              _launchURL(_menuUrls[i].url);
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
                child: Row(children: [
                  Text(
                    _menuUrls[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuUrls[i].iconPath != "")
                    SvgPicture.asset(_menuUrls[i].iconPath,
                        width: MediaQuery.of(context).size.width * 0.05
                  )
                ])),
          ));
        }
      }
    }
    return listItems;
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MenuItem {
  late String _title;
  late String _url;
  late String _iconPath;
  late ScreenArguments? _arguments;

  MenuItem(this._title, this._url, this._iconPath, this._arguments);

  String get iconPath => _iconPath;

  set iconPath(String value) {
    _iconPath = value!;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  ScreenArguments? get arguments => _arguments;

  set arguments(ScreenArguments? value) {
    _arguments = value;
  }
}
