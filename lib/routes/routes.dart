import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery/features/home/presentations/pages/home.dart';
import 'package:fooddelivery/features/restaurant/presentation/pages/restaurant_list.dart';
import 'package:fooddelivery/features/restaurant/presentation/pages/restaurant.dart';
import 'package:fooddelivery/features/restaurant/di/restaurant_module.dart';
import 'package:fooddelivery/features/cart/di/cart_module.dart';
import 'package:fooddelivery/features/cart/presentation/pages/pages.dart';
import 'package:fooddelivery/features/cart/presentation/bloc/bloc.dart';
import 'package:fooddelivery/features/order/di/order_module.dart';
import 'package:fooddelivery/features/order/presentation/pages/order_list.dart';
import 'package:fooddelivery/features/order/presentation/blocs/order_bloc.dart';
import 'package:fooddelivery/features/account/presentation/pages/pages.dart';
import 'package:fooddelivery/ui/splash.dart';

class AppRoutes extends Module {
  @override
  void binds(Injector i) {
    // Import restaurant module bindings
    super.binds(i);
  }

  @override
  List<Module> get imports => [RestaurantModule(), CartModule(), OrderModule()];

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.child(
      '/home',
      child: (context) => BlocProvider.value(
        value: Modular.get<CartBloc>(),
        child: const HomePage(),
      ),
      children: [
        ChildRoute('/', child: (context) => const RestaurantListPage()),
        ChildRoute(
          '/orders',
          child: (context) => BlocProvider(
            create: (context) => OrderBloc(),
            child: const OrderListPage(),
          ),
        ),
        ChildRoute('/account', child: (context) => const AccountPage()),
      ],
    );
    r.child(
      '/restaurant/:id',
      child: (context) => BlocProvider.value(
        value: Modular.get<CartBloc>(),
        child: RestaurantPage(restaurantId: r.args.params['id'] ?? ''),
      ),
    );
    r.child(
      '/cart',
      child: (context) => BlocProvider.value(
        value: Modular.get<CartBloc>(),
        child: const CartPage(),
      ),
    );
    r.child(
      '/orders',
      child: (context) => BlocProvider(
        create: (context) => OrderBloc(),
        child: const OrderListPage(),
      ),
    );
  }
}
