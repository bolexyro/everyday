import 'package:flutter/material.dart';

SnackBar appSnackbar({required String text, Color? color, int? seconds, SnackBarAction? action}) =>
    SnackBar(
      backgroundColor: color,
      content: Text(text),
      duration: Duration(seconds: seconds ?? 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: action,
    );
