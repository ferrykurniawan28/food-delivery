import 'package:flutter_modular/flutter_modular.dart';
import '../data/datasources/restaurant_local_datasource.dart';
import '../data/datasources/restaurant_local_datasource_impl.dart';
import '../data/datasources/restaurant_remote_datasource.dart';
import '../data/datasources/restaurant_remote_datasource_impl.dart';
import '../data/repositories/restaurant_repository_impl.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../domain/usecases/usecases.dart';
import '../presentation/bloc/bloc.dart';

/// Restaurant Module for Flutter Modular dependency injection
class RestaurantModule extends Module {
  @override
  void binds(Injector i) {
    // Bind data sources
    i.addSingleton<RestaurantRemoteDataSource>(
      RestaurantRemoteDataSourceImpl.new,
    );
    i.addSingleton<RestaurantLocalDataSource>(
      RestaurantLocalDataSourceImpl.new,
    );

    // Bind repository
    i.addSingleton<RestaurantRepository>(
      () => RestaurantRepositoryImpl(
        remoteDataSource: i.get<RestaurantRemoteDataSource>(),
        localDataSource: i.get<RestaurantLocalDataSource>(),
      ),
    );

    // Bind use cases
    i.addLazySingleton<GetRestaurantsUseCase>(
      () => GetRestaurantsUseCase(i.get<RestaurantRepository>()),
    );
    i.addLazySingleton<GetRestaurantsByCategoryUseCase>(
      () => GetRestaurantsByCategoryUseCase(i.get<RestaurantRepository>()),
    );
    i.addLazySingleton<SearchRestaurantsUseCase>(
      () => SearchRestaurantsUseCase(i.get<RestaurantRepository>()),
    );
    i.addLazySingleton<GetRestaurantByIdUseCase>(
      () => GetRestaurantByIdUseCase(i.get<RestaurantRepository>()),
    );
    i.addLazySingleton<GetRestaurantsWithFiltersUseCase>(
      () => GetRestaurantsWithFiltersUseCase(i.get<RestaurantRepository>()),
    );
    i.addLazySingleton<GetRestaurantsNearbyUseCase>(
      () => GetRestaurantsNearbyUseCase(i.get<RestaurantRepository>()),
    );

    // Bind BLoC
    i.add<RestaurantBloc>(
      () => RestaurantBloc(
        getRestaurantsUseCase: i.get<GetRestaurantsUseCase>(),
        getRestaurantsByCategoryUseCase: i
            .get<GetRestaurantsByCategoryUseCase>(),
        searchRestaurantsUseCase: i.get<SearchRestaurantsUseCase>(),
        getRestaurantByIdUseCase: i.get<GetRestaurantByIdUseCase>(),
        getRestaurantsWithFiltersUseCase: i
            .get<GetRestaurantsWithFiltersUseCase>(),
        getRestaurantsNearbyUseCase: i.get<GetRestaurantsNearbyUseCase>(),
      ),
    );
  }
}
