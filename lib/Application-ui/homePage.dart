import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/cloud-firestore.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Passwords/code/passwordDetails.dart';
import 'package:safeSpace/Payments/code/paymentDetails.dart';
import 'navigationDrawer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class SafeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SearchBar isSearching = Provider.of<SearchBar>(context);
    return WillPopScope(
          onWillPop: (){
            return (!isSearching.searching)?showExitDialog(context):isSearching.updateSearchBar(false);
            },
          child: MultiProvider(
        providers: [
          StreamProvider<List<Passwords>?>.value(value: FirestoreDatabase.getPasswords(),catchError: (_, __) => null, initialData: [],),
          StreamProvider<List<Passports>?>.value(value: FirestoreDatabase.getPassports(),catchError: (_, __) => null, initialData: [],),
          StreamProvider<List<Payments>?>.value(value: FirestoreDatabase.getPayments(),catchError: (_, __) => null, initialData: [],),
          StreamProvider<List<Certificates>?>.value(value: FirestoreDatabase.getCertificates(),catchError: (_, __) => null, initialData: [],),
          StreamProvider<List<Document>?>.value(value: FirestoreDatabase.getDocuments(),catchError: (_, __) => null, initialData: [],),
          ],
          child: SafeArea(
          child: Scaffold(
          body: Stack(
            children:[
              SafeDrawer(),
              CurrentPage()
            ]
            ),
            ),
          ),
      ),
    );
  }
}
class CurrentPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  final Widget currentPage = Provider.of<Dashboard>(context).dashboardChild;
    return AnimatedContainer(
    duration: Duration(milliseconds: 600),
    transform: (Provider.of<DrawerState>(context).drawerSlide)?(context.isMobileTypeHandset)?(Matrix4.translationValues(160,110,0)..scale(0.78)):(Matrix4.translationValues(110.w,0,0)):(Matrix4.translationValues(0,0,0)),
    child: Material(
      elevation: 10,
      borderRadius: (context.isMobileTypeHandset)?BorderRadius.circular((Provider.of<DrawerState>(context).isDrawerOpen)?20.0:0):null,
      child: currentPage));
  }
}
