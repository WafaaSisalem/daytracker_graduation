import 'package:flutter/cupertino.dart';

class TabModel {
  final Widget content;
  dynamic title;
  final String iconPath;
  TabModel({
    required this.content,
    required this.title,
    required this.iconPath,
  });
}
