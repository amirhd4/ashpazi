import 'package:flutter/material.dart';

class TextFieldWidget {
  static textField(TextEditingController controller,
      Function(String value) function, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        suffixIcon: Icon(
          icon,
          color: Colors.amber,
        ),
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: "bZiba",
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: "bMitra",
      ),
      onChanged: function,
    );
  }

  static search(
      TextEditingController textController, Function(String value) function) {
    return Container(
      padding: const EdgeInsets.all(7.0),
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blueGrey.withOpacity(0.8),
      ),
      child: TextFieldWidget.textField(
        textController,
        function,
        "جستجو",
        Icons.search,
      ),
    );
  }
}
