import 'package:flutter/material.dart';


bool darkMode = false;

void toggleDarkMode(){
  darkMode = !darkMode;
  colorsList = darkMode? {

  "praimryColor": Color.fromRGBO(0, 75, 200, 1),
  "secondaryColor": Color.fromRGBO(200, 25, 200, 1),
  "accentColor": Color.fromRGBO(70, 140, 255, 1),
  "backgroundColor": Color.fromRGBO(30, 30, 30, 1),
  "praimrytext": Color.fromRGBO(255, 255, 255, 1),
  "secondarytext": Color.fromRGBO(180, 180, 180, 1),
  "powercolor":Color.fromRGBO(255, 0, 175, 1),
  "dividerColor":Color.fromRGBO(200, 200, 200, 1),
}:{
 "praimryColor": Color.fromRGBO(0, 75, 175, 1),
  "secondaryColor": Color.fromRGBO(200, 25, 200, 1),
  "accentColor": Color.fromRGBO(70, 140, 255, 1),
  "backgroundColor": Color.fromRGBO(255, 255, 255, 1),
  "praimrytext": Color.fromRGBO(20, 20, 20, 1),
  "secondarytext": Color.fromRGBO(117, 117, 117, 1),
  "powercolor":Color.fromRGBO(0, 111, 152, 1),
  "dividerColor":Color.fromRGBO(210, 210, 210, 1),

};
}

Map <String,Color> colorsList = darkMode? {

  "praimryColor": Color.fromRGBO(0, 75, 200, 1),
  "secondaryColor": Color.fromRGBO(200, 25, 200, 1),
  "accentColor": Color.fromRGBO(70, 140, 255, 1),
  "backgroundColor": Color.fromRGBO(30, 30, 30, 1),
  "praimrytext": Color.fromRGBO(255, 255, 255, 1),
  "secondarytext": Color.fromRGBO(180, 180, 180, 1),
  "powercolor":Color.fromRGBO(255, 0, 175, 1),
  "dividerColor":Color.fromRGBO(200, 200, 200, 1),
}:{
 "praimryColor": Color.fromRGBO(0, 75, 175, 1),
  "secondaryColor": Color.fromRGBO(200, 25, 200, 1),
  "accentColor": Color.fromRGBO(70, 140, 255, 1),
  "backgroundColor": Color.fromRGBO(255, 255, 255, 1),
  "praimrytext": Color.fromRGBO(20, 20, 20, 1),
  "secondarytext": Color.fromRGBO(117, 117, 117, 1),
  "powercolor":Color.fromRGBO(50, 0, 255, 1),
  "dividerColor":Color.fromRGBO(210, 210, 210, 1),

};