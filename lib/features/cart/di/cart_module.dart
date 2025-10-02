import 'package:flutter_modular/flutter_modular.dart';
import '../data/datasources/cart_local_datasource.dart';
import '../data/datasources/cart_local_datasource_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/usecases/usecases.dart';
import '../presentation/bloc/bloc.dart';

class CartModule extends Module {
  @override
  void binds(Injector i) {
    // Data Sources
    i.addSingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl());

    // Repositories
    i.addSingleton<CartRepository>(
      () => CartRepositoryImpl(localDataSource: i.get<CartLocalDataSource>()),
    );

    // Use Cases
    i.addLazySingleton<GetCartUseCase>(
      () => GetCartUseCase(repository: i.get<CartRepository>()),
    );
    i.addLazySingleton<AddItemToCartUseCase>(
      () => AddItemToCartUseCase(repository: i.get<CartRepository>()),
    );
    i.addLazySingleton<RemoveItemFromCartUseCase>(
      () => RemoveItemFromCartUseCase(repository: i.get<CartRepository>()),
    );
    i.addLazySingleton<UpdateItemQuantityUseCase>(
      () => UpdateItemQuantityUseCase(repository: i.get<CartRepository>()),
    );
    i.addLazySingleton<ClearCartUseCase>(
      () => ClearCartUseCase(repository: i.get<CartRepository>()),
    );
    i.addLazySingleton<GetCartItemCountUseCase>(
      () => GetCartItemCountUseCase(repository: i.get<CartRepository>()),
    );

    // BLoC
    i.add<CartBloc>(
      () => CartBloc(
        getCartUseCase: i.get<GetCartUseCase>(),
        addItemToCartUseCase: i.get<AddItemToCartUseCase>(),
        removeItemFromCartUseCase: i.get<RemoveItemFromCartUseCase>(),
        updateItemQuantityUseCase: i.get<UpdateItemQuantityUseCase>(),
        clearCartUseCase: i.get<ClearCartUseCase>(),
        getCartItemCountUseCase: i.get<GetCartItemCountUseCase>(),
      ),
    );
  }
}
