import 'package:flutter/material.dart';

Color darkColor = Colors.black;
Color lightColor = Colors.white;

manuItem(String itelType) {
  switch (itelType) {
    case 'luz':
      return {
        'icon': Icons.lightbulb_outline,
        'backColor': Colors.yellow,
        'text': 'Luces',
        'textColor': darkColor,
        'route': 'luzRoute'
      };
    case 'settings':
      return {
        'icon': Icons.settings,
        'backColor': Colors.red,
        'text': 'Ajustes',
        "textColor": lightColor,
        'route': 'settingsRoute'
      };
  }
}
