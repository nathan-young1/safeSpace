import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:encrypt/encrypt.dart' as externalEncryptPackage;

class UserEncryptionTools{
  /// The Increase User Password that is used to encrypt the Encryption Key before storing it in firestore.
  static late String passwordToEncryptEncryptionKey;
  static late String encryptionKey;

  /// Get the tools needed for encryption in this appilcation.
  static Future<void> initialize({required String userPassword}) async {
    passwordToEncryptEncryptionKey = _increasePasswordLengthTo32(userPassword);
    encryptionKey = await _getUserEncryptionKeyFromDb(increasedPassword: passwordToEncryptEncryptionKey);
  }

  /// Increase the user password to length 32, if it is not up to 32 characters.
  static String _increasePasswordLengthTo32(String passwordToIncreaseLength){
    String key = passwordToIncreaseLength;
    String increasedPassword = '';
    int count = 0;

    for (int i = 1; i <= 32; i++){
      increasedPassword += key[count];
      (count < key.length - 1) ? count++ : count = 0;
    }
    return increasedPassword;
  }

  /// Get the encryption key from firestore and then decrypt it with the user's password.
  static Future<String> _getUserEncryptionKeyFromDb({required String increasedPassword}) async {
    var document = await FirebaseFirestore.instance
      .collection(userUid!)
      .doc(Collection.encryptionKeyDoc)
      .get();

    String encryptionKey = _decryptEncryptionKeyGottenFromOnlineStorage(increasedPassword: increasedPassword,encryptionKeyFromOnlineStorage: document.data()![Collection.encryptionKeyDoc]);

    return encryptionKey;
  }

  /// Generates a random encryption key for a user, then encrypt it with the user's password and store it in firestore.
  static Future<void> setEncryptionKeyForNewUser({required String userPassword}) async {
      String userGeneratedEncryptionKey = externalEncryptPackage.Key.fromSecureRandom(32).base64;
      String encryptedFormatToStoreInDb = _encryptEncryptionKeyForOnlineStorage(
                                            increasedPassword: _increasePasswordLengthTo32(userPassword),
                                            encryptionKey: userGeneratedEncryptionKey);

      await FirebaseFirestore.instance
      .collection(userUid!)
      .doc(Collection.encryptionKeyDoc)
      .set({Collection.encryptionKeyDoc: encryptedFormatToStoreInDb});

    // Then initialize the UserEncryptionTools class.
      await initialize(userPassword: userPassword);
  }

  /// Encryptes the encryptionKey with the user extended password and return the encrypted form.
  static String _encryptEncryptionKeyForOnlineStorage
  ({
    required String increasedPassword,
    required String encryptionKey
    }){
    Key aesKey = Key.fromUtf8(increasedPassword);
    IV aesIv = IV.fromUtf8(userUid!.substring(0, 16));

    // Create an Encrypter
    final Encrypter aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

    // Encrypt the user's Encryption Key for cloud Firestore storage
    final Encrypted aesEncrypted = aesEncrypter.encrypt(encryptionKey, iv: aesIv);
    String result = aesEncrypted.base64.toString();
    return result;
  }

  /// Decrypt the encryptionKey gotten from online storage and return the decrypted form.
  static String _decryptEncryptionKeyGottenFromOnlineStorage
  ({
    required String increasedPassword,
    required String encryptionKeyFromOnlineStorage
    }){
        Key aesKey = Key.fromUtf8(increasedPassword);
        final IV aesIv = IV.fromUtf8(userUid!.substring(0, 16));

        // Create an Encrypter
        final Encrypter aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

        String result = aesEncrypter.decrypt64(encryptionKeyFromOnlineStorage, iv: aesIv);
        return result;
    }
  
  /// ReEncrypt the encryptionKey with the newIncreasedPassword and upload it to Firebase.
  static reEncryptUserEncryptionKeyForOnlineStorage
  ({
    required String newPassword,
  }) async {
    String newIncreasedPassword = _increasePasswordLengthTo32(newPassword);
    String reEncryptedEncryptionKey = _encryptEncryptionKeyForOnlineStorage(increasedPassword: newIncreasedPassword, encryptionKey: encryptionKey);
    
    await FirebaseFirestore.instance
      .collection(userUid!)
      .doc(Collection.encryptionKeyDoc)
      .update({Collection.encryptionKeyDoc: reEncryptedEncryptionKey});
  }

  static clear(){
    encryptionKey = "";
    passwordToEncryptEncryptionKey = "";
  }
}