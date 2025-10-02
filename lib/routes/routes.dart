import 'package:flutter_modular/flutter_modular.dart';
import 'package:fooddelivery/features/home/presentations/pages/home.dart';
import 'package:fooddelivery/features/restaurant/presentation/pages/restaurant_list.dart';
import 'package:fooddelivery/features/restaurant/presentation/pages/restaurant.dart';
import 'package:fooddelivery/features/restaurant/di/restaurant_module.dart';
import 'package:fooddelivery/ui/splash.dart';

class AppRoutes extends Module {
  @override
  void binds(Injector i) {
    // Import restaurant module bindings
    super.binds(i);
  }

  @override
  List<Module> get imports => [RestaurantModule()];

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
    r.child(
      '/restaurant/:id',
      child: (context) =>
          RestaurantPage(restaurantId: r.args.params['id'] ?? ''),
    );
  }
}
