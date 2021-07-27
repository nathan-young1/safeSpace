import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:aes_crypt/aes_crypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/userEncryptionTools.dart';
import 'package:safeSpace/Vault-Recryption/mainReEncryptionFunction.dart';
import 'enum.dart';
import 'package:uuid/uuid.dart';


encrypt([String plainText = '',Cyptography mode = Cyptography.Normal]) async {
  if (plainText != ''){
  var aesKey = Key.fromUtf8(UserEncryptionTools.encryptionKey);

  final aesIv = IV.fromUtf8(userUid.substring(0, 16));
  final aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

  final aesEncrypted = aesEncrypter.encrypt(plainText, iv: aesIv);
  String result = aesEncrypted.base64.toString();
  return result;
  }else{
    return plainText;
  }
}

decrypt([String textToDecrypt = '',Cyptography mode = Cyptography.Normal]) async {
  if (textToDecrypt != ''){
  var aesKey = Key.fromUtf8(UserEncryptionTools.encryptionKey);

  final aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));
  final aesIv = IV.fromUtf8(userUid.substring(0, 16));

  String result = aesEncrypter.decrypt64(textToDecrypt, iv: aesIv);
  return result;
  }else{
    return textToDecrypt;
  }
}


// ignore: missing_return
Future<Map<FileEncrypt, dynamic>?> fileEncrypt(File file,{Cyptography mode = Cyptography.Normal}) async {
  final String uuid = Uuid().v1();
  var crypt = AesCrypt(UserEncryptionTools.encryptionKey);
  crypt.setOverwriteMode(AesCryptOwMode.on);
  final Directory systemTempDir = Directory.systemTemp;
  File tempFile = File('${systemTempDir.path}/encrypt$uuid.txt.aes');
  if (tempFile.existsSync()) {
    await tempFile.delete();
  }
  await tempFile.create();
  crypt.encryptFileSync(file.path, tempFile.path);
  return {FileEncrypt.file: tempFile,FileEncrypt.filePath: tempFile.path};
}


fileDecrypt(File file, String filePath, String collection, String docName,{Cyptography mode = Cyptography.Normal}) async {
  if(mode == Cyptography.Normal){
  var crypt = AesCrypt(UserEncryptionTools.encryptionKey);
  crypt.setOverwriteMode(AesCryptOwMode.on);
  if (await Permission.storage.request().isGranted) {
    String fullPath = '${GetDirectories.pathToVaultFolder}/$collection/$docName';
    String fileStoragePath;
    if (!Directory(fullPath).existsSync()) {
      new Directory(fullPath).createSync(recursive: true);
    }
    fileStoragePath = fullPath;
    File permanentFile = File('$fileStoragePath/$filePath');
    permanentFile.create();
    crypt.decryptFileSync(file.path, permanentFile.path);
  }
  }else if(mode == Cyptography.ReEncryption){
    var crypt = AesCrypt(VaultReEncryption?.masterKey);
    crypt.setOverwriteMode(AesCryptOwMode.on);
    File tempFile = File('${GetDirectories.systemTempDir.path}/Decrypted $docName');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    crypt.decryptFileSync(file.path, tempFile.path);
    return tempFile;
  }
}