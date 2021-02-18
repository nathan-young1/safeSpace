import 'package:encrypt/encrypt.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Vault-Recryption/mainReEncryptionFunction.dart';

reEncryptData({String plainText = ''}) async {
  if (plainText != ''){
  final aesKey = Key.fromUtf8(VaultReEncryption?.newVaultKey);
  final aesIv = IV.fromUtf8(userUid.substring(0, 16));
  final aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

  final aesEncrypted = aesEncrypter.encrypt(plainText, iv: aesIv);
  String result = aesEncrypted.base64.toString();
  return result;
  }else{
    return plainText;
  }
}