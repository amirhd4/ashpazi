import 'package:ashpazi/common/app.dart';
import 'package:flutter/material.dart';

class AppBarWidget {
  static AppBar appBar(String? title, BuildContext context, Color? color,
      {Widget? leading, Widget? titleWidget, List<Widget>? actions}) {
    return AppBar(
      backgroundColor: color,
      foregroundColor: AppBarInfo.foreColor,
      elevation: 0.0,
      leading: leading,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          width: AppBarInfo.getAppBarBottomBorderSize(context),
          height: AppBarInfo.borderHeight,
          decoration: BoxDecoration(
            gradient: AppBarInfo.linearGradient,
            borderRadius: Borders.borderRadiusForBorder,
            boxShadow: AppBarInfo.shadow,
          ),
        ),
      ),
      title: titleWidget ??
          Text(
            title!,
            style: AppBarInfo.appBarTitleStyle,
          ),
      centerTitle: true,
    );
  }
}
