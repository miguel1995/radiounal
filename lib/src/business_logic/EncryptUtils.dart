import 'package:encrypt/encrypt.dart';

class EncryptUtils {

  final key = Key.fromUtf8('R2SwTPQVUvbBMTYxODQ2MjgwMDAwMA=='); //32 chars
  final iv = IV.fromUtf8('RtIBovq3Xs8XkC81'); //16 chars

//   Flutter encryption
  String encryp(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
//   print('text : $text');
//   print('encrypted : ${encrypted.base64}');
    return encrypted.base64;
  }

//Flutter decryption
  String decryp(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decrypted;
  }

}