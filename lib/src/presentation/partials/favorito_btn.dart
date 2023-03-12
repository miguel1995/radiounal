import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:platform_device_id/platform_device_id.dart';

class FavoritoBtn extends StatefulWidget {
  final int uid; //Indica el id del episodio de podcast o emisora de radio
  final String message;

  const FavoritoBtn({Key? key, required this.uid, required this.message}) : super(key: key);


  @override
  State<FavoritoBtn> createState() => _FavoritoBtnState();
}

class _FavoritoBtnState extends State<FavoritoBtn> {
  bool _isFavorito = false;
  String? _deviceId;
  late FirebaseLogic firebaseLogic;
  late int uid; //Indica el id del episodio de podcast o emisora de radio
  late String message;


  @override
  void initState() {
    uid = widget.uid;
    message = widget.message;


    firebaseLogic = FirebaseLogic();
    initPlatformState();

  } // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
    print("deviceId->$_deviceId");

    firebaseLogic.validateFavorite(uid, _deviceId).then(
            (value) => {
          setState(()=>{
            _isFavorito = value
          })
        });

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {

          if(_isFavorito == true){
            firebaseLogic.eliminarFavorite(uid, _deviceId).then((value) => {
              setState((){
                _isFavorito = false;
              })
            });
          }else{
            firebaseLogic.agregarFavorito(uid, message, (message == "RADIO") ? "EMISION" : "EPISODIO", _deviceId).then(
                    (value) => {
                  if(value == true){
                    //print('DocumentSnapshot added with ID: ${doc.id}');
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Agregado a mis favoritos"))
                    ),
                    setState((){
                      _isFavorito = true;
                    })
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Se ha presentado un problema, intentelo más tarde"))
                    )
                  }
                });
          }
        },
        child: Container(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child:  (_isFavorito==true)? SvgPicture.asset('assets/icons/icono_corazon_completo.svg',
              color: Colors.white,
            ) :
            SvgPicture.asset('assets/icons/icono_corazon_borde.svg',
            color: Colors.white,
            )
        )

    );
  }
}
