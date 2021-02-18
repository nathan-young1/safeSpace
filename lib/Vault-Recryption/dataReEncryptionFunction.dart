import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/cloud-firestore.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Passwords/code/passwordDetails.dart';
import 'package:safeSpace/Payments/code/paymentDetails.dart';
import 'package:safeSpace/Vault-Recryption/aesReEncrypt.dart';

Future reEncryptPassword(List<Passwords> passwords) async {
  print('started password');
    for(Passwords password in passwords){
    Map passwordMap = Map<String, dynamic>();
    passwordMap['Title'] = await reEncryptData(plainText: password.title);
    passwordMap['Username'] = await reEncryptData(plainText: password.username);
    passwordMap['Password'] = await reEncryptData(plainText: password.password);
    passwordMap['Networkurl'] = await reEncryptData(plainText: password.networkUrl);
    await FirestoreDatabase.database
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.passwords)
      .doc(password.dbName)
      .update(passwordMap);
      print('finished document');
    }
}

Future reEncryptPassport(List<Passports> passports) async {
  print('started passport');
    for(Passports passport in passports){
      print(passport);
    Map identityMap = Map<String, dynamic>();
    identityMap['Name'] = await reEncryptData(plainText: passport.name);
    identityMap['Nationality'] = await reEncryptData(plainText: passport.nationality);
    identityMap['Gender'] = await reEncryptData(plainText: passport.gender);
    identityMap['Country'] = await reEncryptData(plainText: passport.country);
    identityMap['Id Number'] = await reEncryptData(plainText: passport.idNumber);
    identityMap['Type Of Passport'] = await reEncryptData(plainText: passport.typeOfPassport);
    identityMap['Passport Number'] = await reEncryptData(plainText: passport.passportNumber);
    identityMap['Issued Date'] = await reEncryptData(plainText: passport.issuedDate);
    identityMap['Expiration Date'] = await reEncryptData(plainText: passport.expireDate);
    identityMap['Date Of Birth'] = await reEncryptData(plainText: passport.birthDate);
    identityMap['Issued Authority'] = await reEncryptData(plainText: passport.issuedAuthority);
    await FirestoreDatabase.database
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.passports)
      .doc(passport.dbName)
      .update(identityMap);
      print('finished document');
    }

}

Future reEncryptPayment(List<Payments> payments) async {
  print('started payment');
    for(Payments payment in payments){
      print(payment);
    Map paymentMap = Map<String, dynamic>();
    paymentMap['Name'] = await reEncryptData(plainText: payment.name);
    paymentMap['Name On Card'] = await reEncryptData(plainText: payment.nameOnCard);
    paymentMap['Type Of Card'] = await reEncryptData(plainText: payment.typeOfCard);
    paymentMap['Number On Card'] = await reEncryptData(plainText: payment.numberOnCard);
    paymentMap['Security Code'] = await reEncryptData(plainText: payment.securityCode);
    paymentMap['Expiration Date'] = await reEncryptData(plainText: payment.expirationDate);
    paymentMap['Image Url'] = await reEncryptData(plainText: payment.image);
    await FirestoreDatabase.database
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.payments)
      .doc(payment.dbName)
      .update(paymentMap);
      print('finished document');
    }
}

Future reEncryptDocument(List<Document> documents) async {
  print('started documents');
    for(Document document in documents){
      print(document);
    Map documentMap = Map<String, dynamic>();
    documentMap['Name Of Document'] = await reEncryptData(plainText: document.nameOfDocument);
    documentMap['Note'] = await reEncryptData(plainText: document.note);
    await FirestoreDatabase.database
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.documents)
      .doc(document.dbName)
      .update(documentMap);
      print('finished document');
    }
}

Future reEncryptCertificate(List<Certificates> certificates) async {
  print('Started Certificates');
    for(Certificates certificate in certificates){
      print(certificate);
    Map certificatesMap = Map<String, dynamic>();
    certificatesMap['Name'] = await reEncryptData(plainText: certificate.name);
    certificatesMap['Type Of Certificate'] = await reEncryptData(plainText: certificate.typeOfCertificate);
    certificatesMap['College'] = await reEncryptData(plainText: certificate.college);
    certificatesMap['Year Of Graduation'] = await reEncryptData(plainText: certificate.yearOfGraduation);
    await FirestoreDatabase.database
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.certificates)
      .doc(certificate.dbName)
      .update(certificatesMap);
      print('finished document');
    }

}