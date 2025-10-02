import 'package:flutter_modular/flutter_modular.dart';
import '../presentation/blocs/order_bloc.dart';

class OrderModule extends Module {
  @override
  void exportedBinds(Injector i) {
    // Order BLoC - exported so other modules can access it
    i.addSingleton<OrderBloc>(() => OrderBloc());
  }
}
