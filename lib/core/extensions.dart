import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  NavigatorState get navigator => Navigator.of(this);

  MaterialPageRoute route(Widget route) =>
      MaterialPageRoute(builder: (context) => route);


  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

extension DateTimeExtension on DateTime {
  String get formatDateWithShortDay =>
      DateFormat('EEE dd MMM yyy').format(this);
}

extension AssetExtension on String {
  String get png => 'assets/pngs/$this.png';
  String get svg => 'assets/svgs/$this.svg';
  String get json => 'assets/jsons/$this.json';
}