import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';

class NoInternetConnection extends StatefulWidget {
  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  bool retrying = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: (!retrying)?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.wifi_off,color: secondaryColor,size: 35),
            SizedBox(width: 10),
            Text('No internet connection')
          ],),
          SizedBox(height: 6),
          RaisedButton(onPressed: () async {
            setState(()=> retrying = true);
            await Future.delayed(Duration(seconds: 2)).then((_) => (mounted)?setState(()=> retrying = false):retrying = false);
          },
          child: Text('Retry'),)
        ],
      ):CircularProgressIndicator(),
    );
  }
}