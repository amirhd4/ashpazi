import 'package:flutter/material.dart';

class SnackBarWidget {
  static snackBar(String title, BuildContext context,
      {Color? foreColor, Color? backColor}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        elevation: 0,
        backgroundColor: backColor ?? Colors.blue.withOpacity(0.5),
      ),
    );
  }
}
