import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';


class FirebaseLogic{

  late final FirebaseFirestore db; //Gestiona el uso de firestore database
  late final FirebaseMessaging _fcm; // Gestiona el uso de FirebaseMessagin (push notifications)


  FirebaseLogic(){
    db = FirebaseFirestore.instance;
    _fcm = FirebaseMessaging.instance;
  }

  Future<bool> agregarFavorito(uid, message, tipo, userId)async{

    bool flag = false;

    // Agragar un favorito a la base de datos en firebase
    final newDocument = <String, dynamic>{
      "uid": uid,
      "sitio": message, //RADIO o PODCAST
      "tipo": tipo,
      "userId": userId
    };

      // Add a new document with a generated ID
      await db.collection("favoritos").add(newDocument).then((DocumentReference doc) =>
      {
          if(doc.id != null){
            //print('DocumentSnapshot added with ID: ${doc.id}');
            flag = true
          }
      }

    );

    return flag;
  }
  final _subjectFavorite = BehaviorSubject<bool>();
  BehaviorSubject<bool> get subjectFavorite => _subjectFavorite;

  validateFavorite(uid, userId)  async {
    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    bool flag = false;


    final docRef = db
        .collection("favoritos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId);

    docRef.snapshots().listen(

          (event) => {
            //print("current data: ${event.docs.length}"),
            if(event.docs.length > 0){

              flag = true,
              _subjectFavorite.sink.add(flag)

        }else{

              flag = false,
              _subjectFavorite.sink.add(flag)

              }



          },
          onError: (error) => print("Listen failed: $error")

    );

    /*await db
        .collection("favoritos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (res) => {
              if(res.docs.length > 0){
                print(">>> registros en Firebase ${res.docs.length}"),
                flag = true
              }

      },
      onError: (e) => print("Error completing: $e"),
    );*/

    //return flag;
    //return false;

  }

  Future<bool> eliminarFavorite(uid, userId)  async {
    bool flag = false;

    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    await db
        .collection("favoritos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
          for (var doc in snapshot.docs) {
                await doc.reference.delete().then(
                        (value) => {

                  }
                )
          }

      },
      onError: (e) => print("Error completing: $e"),
    );

    return flag;

  }

  Future<List<Map<String, dynamic>>> findFavoriteByUserUid(userId)  async {
    List<Map<String, dynamic>> listDocs = [];

    //Busca todos los favoritos de un usuario
    await db
        .collection("favoritos")
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
          listDocs = snapshot.docs.map((doc) => doc.data()).toList()

      },
      onError: (e) => print("Error completing: $e"),
    );

    return listDocs;

  }

  Future<bool> agregarSeguido(uid, message, tipo, userId)async{

    bool flag = false;

    // Agragar un favorito a la base de datos en firebase
    final newDocument = <String, dynamic>{
      "uid": uid,
      "sitio": message, //RADIO o PODCAST
      "tipo": tipo,
      "userId": userId
    };

    // Add a new document with a generated ID
    await db.collection("seguidos").add(newDocument).then((DocumentReference doc) =>
    {
      if(doc.id != null){
        //print('DocumentSnapshot added with ID: ${doc.id}');
        flag = true
      }
    }

    );

    return flag;
  }


  Future<List<Map<String, dynamic>>> findSeguidosByUserUid(userId)  async {
    List<Map<String, dynamic>> listDocs = [];

    //Busca todos los favoritos de un usuario
    await db
        .collection("seguidos")
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
        listDocs = snapshot.docs.map((doc) => doc.data()).toList()

      },
      onError: (e) => print("Error completing: $e"),
    );

    return listDocs;

  }

  Future<bool> eliminarSeguido(uid, userId)  async {
    bool flag = false;

    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    await db
        .collection("seguidos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
        for (var doc in snapshot.docs) {
          await doc.reference.delete().then(
                  (value) => {

              }
          )
        }

      },
      onError: (e) => print("Error completing: $e"),
    );

    return flag;

  }

  Future<bool> validateSeguido(uid, userId)  async {
    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    bool flag = false;
    await db
        .collection("seguidos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (res) => {
        if(res.docs.length > 0){
          flag = true
        }

      },
      onError: (e) => print("Error completing: $e"),
    );

    return flag;

  }






}