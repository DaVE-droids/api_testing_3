import 'dart:ui';
import 'package:flutter/material.dart';
var scaffoldKey = GlobalKey<ScaffoldState>();
PreferredSizeWidget MyAppBar() {
  return AppBar(
      leading: IconButton(onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
          icon: Image.asset('assets/images/button.jpg', fit: BoxFit.fill,)),
      centerTitle: true,
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      title: Text(
        'African Weather',
        style:
        TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,

        ),
      ),
    );
}