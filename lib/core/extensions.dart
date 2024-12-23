import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';

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
      DateFormat('EEE, dd MMM yyy').format(this);

  String get formatDateWithShortDayWithTime =>
      DateFormat('EEE, dd MMM yyy · HH:mm').format(this);
}

extension AssetExtension on String {
  String get png => 'assets/pngs/$this.png';
  String get svg => 'assets/svgs/$this.svg';
  String get json => 'assets/jsons/$this.json';
}

extension FileExtension on File {
  Future<String> size(int decimals) async {
    int bytes = await length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

extension ConnectionStatusExtension on ConnectionStatus{
  bool get isConnected => this == ConnectionStatus.connected;
}
