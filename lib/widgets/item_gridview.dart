import 'package:ashpazi/widgets/text.dart';
import 'package:flutter/material.dart';

class GridViewItemWidget {
  static item(String title, Function doAction, IconData? icon,
      {double? fontSize}) {
    return GestureDetector(
      onTap: () {
        doAction();
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.multiply,
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue.shade900,
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: const Color.fromARGB(255, 237, 255, 76),
                    size: 35,
                  )
                : Container(),
            fontSize != null
                ? TextWidget.textBold(title, color: Colors.white)
                : TextWidget.splashText(title),
          ],
        ),
      ),
    );
  }
}
