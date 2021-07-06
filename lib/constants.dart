import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color cThemeColor = HexColor("#030A8C"); //red
final Color cPrimaryColor =
    Colors.purpleAccent; //HexColor("#D9933D"); //dee blue
// final Color cTextColor = Colors.white;
final Color cSecondaryColor = HexColor("#F27244"); //orange
final Color cTertiryColor = HexColor("#F29863"); //orangish
final Color cBackgroundColor = HexColor("#7883BF"); //really fainted orange

final TextStyle aLittleBetter = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Colors.white,
);

final List<String> avatars = [
  "Assets/1.png",
  "Assets/2.png",
  "Assets/3.png",
  "Assets/4.png",
  "Assets/5.png",
  "Assets/6.png",
  "Assets/7.png",
  "Assets/8.png",
  "Assets/9.png",
];

final List<Color> priorityColors = [
  Colors.cyan,
  Colors.greenAccent,
  Colors.redAccent
];
