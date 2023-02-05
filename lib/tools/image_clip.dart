import 'package:flutter/cupertino.dart';

class ImageClipper extends CustomClipper<Path> {
  BuildContext context;
  ImageClipper(this.context);

  @override
  getClip(Size size) {
    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width / 3, size.height),
          const Radius.circular(30),
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width / 3, 0, size.width / 3, size.height),
          const Radius.circular(30),
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width / 3 * 2, 0, size.width / 3, size.height),
          const Radius.circular(30),
        ),
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
