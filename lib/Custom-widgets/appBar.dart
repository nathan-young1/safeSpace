import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:velocity_x/velocity_x.dart';

StreamController searchBarStateController = StreamController();

class CustomAppBar extends StatefulWidget {
  final String collection;
  CustomAppBar({required this.collection});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  TextEditingController searchBar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DrawerState size = Provider.of<DrawerState>(context);
    SearchBar isSearching = Provider.of<SearchBar>(context);
    return (!isSearching.searching)
            ? AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: (Provider.of<DrawerState>(context).isDrawerOpen)
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w, color: Colors.black),
                        onPressed: () => size.closeDrawer())
                    : IconButton(
                        onPressed: () => size.openDrawer(),
                        icon: Icon(MdiIcons.sortVariant,size: (context.isMobileTypeHandset)?30:19.w, color: Colors.black)),
                ),
                  title: Text('${widget.collection}',style: Theme.of(context).appBarTheme.textTheme!.headline1),
                  actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,8,0),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.black, size: (context.isMobileTypeTablet)?18.w:null),
                      onPressed: () => isSearching.updateSearchBar(true)),
                  )
                  ],
                )
          : AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(8,0,0,0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,color: Colors.black, size: (context.isMobileTypeTablet)?16.w:null),
                  onPressed: () {
                    setState(() {
                      query = '';
                      searchBar.text = '';
                      isSearching.updateSearchBar(false);
                      searchBarStateController.add(null);
                    });
                  },
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,8,0),
                  child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black, size: (context.isMobileTypeTablet)?16.w:null),
                      onPressed: () => setState((){ 
                        searchBar.text = '';
                        query = '';
                        searchBarStateController.add(null);
                        })),
                )
              ],
              title: Container(
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                width: 250.w,
                child: TextField(
                  controller: searchBar,
                  style: authTextField,
                  onChanged: (value) {
                    setState(() =>query = value);
                    searchBarStateController.add(null);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 19)),
                  ),
                  ));
  }
}