import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  NavigatorState get navigator => Navigator.of(this);

  MaterialPageRoute route(Widget route) =>
      MaterialPageRoute(builder: (context) => route);
}
