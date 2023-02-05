import 'package:ashpazi/cubits/ashpazi_cubit.dart';
import 'package:ashpazi/cubits/foodlist_cubit.dart';
import 'package:ashpazi/cubits/scheduling_cubit.dart';
import 'package:ashpazi/screens/food_list/foodlist_screen.dart';
import 'package:ashpazi/screens/home_page.dart';
import 'package:ashpazi/screens/resource_screen.dart';
import 'package:ashpazi/screens/scheduling/scheduling_screen.dart';
import 'package:ashpazi/screens/splash_screen.dart';
import 'package:ashpazi/screens/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static MaterialPageRoute directionalityPageRoute(StatefulWidget stfulClass) {
    return MaterialPageRoute(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AshpaziCubit()),
            BlocProvider(create: (context) => SchedulingCubit()),
            BlocProvider(create: (context) => FoodListCubit()),
          ],
          child: stfulClass,
        ),
      ),
    );
  }

  static Route? routes(RouteSettings settings) {
    switch (settings.name) {
      case "/splash":
        return directionalityPageRoute(
          const SplashScreen(),
        );
      case "/home":
        return directionalityPageRoute(
          const MyHomePage(),
        );
      case "/tutorial":
        return directionalityPageRoute(
          const TutorialScreen(),
        );
      case "/scheduling":
        return directionalityPageRoute(
          const SchedulingScreen(),
        );
      case "/foodlist":
        return directionalityPageRoute(
          const FoodListScreen(),
        );
      case "/resource":
        return directionalityPageRoute(
          const ResourceScreen(),
        );
      default:
        return null;
    }
  }
}
