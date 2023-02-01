import 'package:flutter/material.dart';

class AppBarRadio extends StatelessWidget   with PreferredSizeWidget{
  const AppBarRadio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(20))),
        title: Center(
            child: Image.asset('assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.5)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/browser');
            }
          )
        ]);
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
