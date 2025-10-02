import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/features/home/presentations/pages/home.dart';
import 'package:fooddelivery/features/restaurant/presentation/pages/restaurant_list.dart';
import 'package:fooddelivery/ui/splash.dart';

class AppRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.child(
      '/home',
      child: (context) => const HomePage(),
      children: [
        ChildRoute('/', child: (context) => const RestaurantListPage()),
      ],
    );
  }
}
