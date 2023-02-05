import 'dart:ui';

import 'package:ashpazi/common/app.dart';
import 'package:flutter/material.dart';

class ButtonWidget {
  static elevatedButton(
      BuildContext context, Function func, String title, double width,
      {int? count, String? picture}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: SizedBox(
          width: GetSizes.getWidth(width, context),
          child: ElevatedButton(
            style: Buttons.buttonStyle,
            onPressed: () => func(),
            child: Row(
              mainAxisAlignment: count != null || picture != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Buttons.buttonTitleSize,
                    color: Buttons.foreColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                count != null
                    ? Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontFamily: "bMitra",
                        ),
                      )
                    : picture != null
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image(
                                image: AssetImage("assets/images/$picture"),
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
