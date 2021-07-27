import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Passwords/code/passwordDetails.dart';
import 'package:safeSpace/Payments/code/paymentDetails.dart';

class FirestoreDatabase {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static Stream<List<Passwords>> getPasswords() {
    return database
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.passwords)
        .orderBy('Time Stamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Passwords> decrypted = [];
          for(var password in snapshot.docs){
            dynamic stream = await decryptPasswordStream(password.data(),password.id);
            decrypted.add(stream);
          }
          return decrypted;
          }
          );
  }

  static Stream<List<Passports>> getPassports() {
    return database
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.passports)
        .orderBy('Time Stamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Passports> decrypted = [];
          for(var passport in snapshot.docs){
            dynamic stream = await decryptPassportStream(passport.data(),passport.id);
            decrypted.add(stream);
          }
          return decrypted;
          }
          );
  }

  static Stream<List<Payments>> getPayments() {
    return database
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.payments)
        .orderBy('Time Stamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Payments> decrypted = [];
          for(var payment in snapshot.docs){
            dynamic stream = await decryptPaymentStream(payment.data(),payment.id);
            decrypted.add(stream);
          }
          return decrypted;
          }
          );
  }

  static Stream<List<Certificates>> getCertificates() {
    return database
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.certificates)
        .orderBy('Time Stamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Certificates> decrypted = [];
          for(var certificate in snapshot.docs){
            dynamic stream = await decryptCertificateStream(certificate.data(),certificate.id);
            decrypted.add(stream);
          }
          return decrypted;
          }
          );
  }

  static Stream<List<Document>> getDocuments() {
    return database
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.documents)
        .orderBy('Time Stamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Document> decrypted = [];
          for(var document in snapshot.docs){
            dynamic stream = await decryptDocumentStream(document.data(),document.id);
            decrypted.add(stream);
          }
          return decrypted;
          }
          );
  }
}
