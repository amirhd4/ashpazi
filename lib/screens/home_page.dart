import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/widgets/appbar.dart';
import 'package:ashpazi/widgets/item_gridview.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey global = GlobalKey();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBar(
          AppBarInfo.titleHomePage, context, AppBarInfo.backColor),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/cooking_picture.png"),
              fit: BoxFit.cover),
        ),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 0,
            childAspectRatio: 2.2,
          ),
          children: [
            GridViewItemWidget.item("دیدن فهرست", () {
              Navigator.pushNamed(context, "/foodlist");
            }, Icons.list_alt),
            GridViewItemWidget.item("زمانبندی پخت غذا", () {
              Navigator.pushNamed(context, "/scheduling");
            }, Icons.schedule),
            GridViewItemWidget.item(HomePageInfo.homePageButton3, () {
              Navigator.pushNamed(
                context,
                "/tutorial",
              );
            }, Icons.food_bank),
            GridViewItemWidget.item("منابع مورد استفاده", () {
              Navigator.pushNamed(
                context,
                "/resource",
              );
            }, Icons.web_rounded),
          ],
        ),
      ),
    );
  }
}
