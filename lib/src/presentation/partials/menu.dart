import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

    bool isHidden = true;

   final List<MenuItem> _menuTitles = [
    MenuItem('Programas Radio UNAL', "/content", null),
    MenuItem('Series Podcast Radio UNAL', "/content", null),
    MenuItem('Favoritos ', "/favourites", Icons.favorite_border),
    MenuItem('Siguiendo', "/followed", null),
    MenuItem('Configuración', "/configurations", null),
    MenuItem('Acerca de esta App', "/about", null),
    MenuItem('Contáctenos', "/contacts", null),
    MenuItem('Política de privacidad', "/politics", null),
    MenuItem('Créditos', "/credits", null),
    MenuItem('Glosario',"/glossary",null)
  ];

   final List<MenuItem> _menuUrls = [
     MenuItem('UNIMEDIOS', "https://unimedios.unal.edu.co/", Icons.exit_to_app),
    MenuItem('Agencia UNAL', "https://agenciadenoticias.unal.edu.co/", null),
    MenuItem('Periódico UNAL', "https://periodico.unal.edu.co/", null),
    MenuItem('Televisión UNAL ', "https://television.unal.edu.co/", null)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      )),
    );
  }

  Widget _buildFlutterLogo() {
    return Container(
      child: Image.network("https://radio.unal.edu.co/fileadmin/_processed_/0/3/csm_2021.06.03_RADIO_UNAL_Identificador_Amarillo_f582116fe7.png"),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildListItems(),
        const Divider(
          color: Colors.red,
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

      listItems.add(
          GestureDetector(
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
              Navigator.pushNamed(context, _menuTitles[i].url);

            },
            child:

            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
          child:

          Row(
            children: [
              Text(
                _menuTitles[i].title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.black
                ),
              ),
                if(_menuTitles[i].iconData!=null)
                  Icon(_menuTitles[i].iconData)

            ],
          )
        ))
      );
    }
    return listItems;
  }

   List<Widget> _buildListUrls() {

    final listItems = <Widget>[];
    late var borderHorizontal = 0.0;
    for (var i = 0; i < _menuUrls.length; ++i) {

      if(i==0){
        listItems.add(

            Row(children:[
              GestureDetector(
                onTap: () {
                  _launchURL(_menuUrls[i].url);
                },
                child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
                    child:


                    Row(
                        children: [

                          Text(
                            _menuUrls[i].title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black),
                          ),
                          if(_menuUrls[i].iconData!=null)
                            Icon(_menuUrls[i].iconData)
                        ]
                    )
                ),
              ),
                IconButton(
                    onPressed: (){
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down))
            ]
            )

        );


        }else{
        if(!isHidden){
          listItems.add(


                GestureDetector(
                  onTap: () {
                    _launchURL(_menuUrls[i].url);
                  },
                  child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
                      child:


                      Row(
                          children: [

                            Text(
                              _menuUrls[i].title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.black),
                            ),
                            if(_menuUrls[i].iconData!=null)
                              Icon(_menuUrls[i].iconData)
                          ]
                      )
                  ),
                )


          );
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


class MenuItem{
  late String _title;
  late String _url;
  late IconData? _iconData;


  MenuItem(this._title, this._url, this._iconData);

  IconData? get iconData => _iconData;

  set iconData(IconData? value) {
    _iconData = value!;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


}