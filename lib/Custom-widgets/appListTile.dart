import 'package:flutter/material.dart';
import 'package:safeSpace/Styles/textStyle.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  AppListTile({this.title,this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(15,10,5,10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Text(
          this.title,
          style: listTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          this.subtitle,
          style: listTextStyle,
          overflow: TextOverflow.ellipsis,
        )
      ],)),
    );
  }
}