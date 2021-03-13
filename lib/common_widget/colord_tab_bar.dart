import 'package:flutter/material.dart';

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar}) : super(color: color, child: tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;
}