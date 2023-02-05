import 'package:flutter/material.dart';

class AppInfo {
  // Title
  static String title = "برنامه آشپزی";
  static List<String> foodCategory = [
    "محبوب",
    "فست فود",
    "دسر",
    "خارجی",
    "آذربایجان شرقی",
    "آذربایجان غربی",
    "اردبیل",
    "اصفهان",
    "البرز",
    "ایلام",
    "بوشهر",
    "تهران",
    "چهار محال و بختیاری",
    "خراسان جنوبی",
    "خراسان رضوی",
    "خراسان شمالی",
    "خوزستان",
    "زنجان",
    "سمنان",
    "سیستان و بلوچستان",
    "فارس",
    "قزوین",
    "قم",
    "کردستان",
    "کرمان",
    "کرمانشاه",
    "کهگیلویه و بویراحمد",
    "گلستان",
    "گیلان",
    "لرستان",
    "مازندران",
    "مرکزی",
    "هرمزگان",
    "همدان",
    "یزد",
  ];
}

class Buttons {
  // Button Style
  static ButtonStyle buttonStyle = ButtonStyle(
    shadowColor: MaterialStateProperty.all(Colors.red),
    elevation: MaterialStateProperty.all(0.0),
    backgroundColor: MaterialStateProperty.all(
      Colors.blue.shade600.withOpacity(0.4),
    ),
  );
  // Color
  static Color foreColor = Colors.white;
  // Size
  static double buttonTitleSize = 25.0;
}

class HomePageInfo {
  // Color
  static LinearGradient background = const LinearGradient(colors: [
    Color.fromARGB(255, 243, 23, 210),
    Color.fromARGB(255, 255, 158, 240),
  ]);
  // Sizes
  static double buttonWidth = 70;
  // Titles
  static String homePageButton1 = "ایجاد فهرست غذا";
  static String homePageButton2 = "مشاهده فهرست غذایی";
  static String homePageButton3 = "آموزش آشپزی";
}

class SplashScreenInfo {
  // Color
  static Color splashBackColor = const Color.fromARGB(255, 16, 92, 190);
  static Color splashTextColor = Colors.white;
  // String
  static String splashText = "با سرآشپز، آشپزیتو مدیریت کن!";
  // Size
  static double splashTextSize = 35;
  // Druation
  static int duration = 2;
}

class TutorialScreenInfo {
  // Sizes
  static double itemWidth = 70;
}

class Borders {
  // Borders
  static BorderRadius borderRadiusForBorder = BorderRadius.circular(5.0);
}

class AppBarInfo {
  // Text
  static String titleHomePage = "خانه";
  // Size
  static TextStyle appBarTitleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  static double bottomBorderSize = 95.5;
  static double borderHeight = 2.0;
  // Color
  static List<BoxShadow> shadow = const [
    BoxShadow(
      color: Colors.blue,
      blurRadius: 5,
      offset: Offset(0.0, 2.0),
    ),
  ];
  static Color borderColor = Colors.blueAccent;
  static Color foreColor = Colors.black;
  static Color backColor = Colors.transparent;
  static LinearGradient linearGradient = LinearGradient(colors: [
    Colors.blue.shade600,
    Colors.blue.shade300,
    Colors.lightBlue.shade50
  ]);

  static getAppBarBottomBorderSize(BuildContext context) =>
      GetSizes.getWidth(bottomBorderSize, context);
}

class GetSizes {
  static getWidth(double percent, BuildContext context) =>
      MediaQuery.of(context).size.width * percent / 100;
  static getHeight(double percent, BuildContext context) =>
      MediaQuery.of(context).size.height * percent / 100;
}
