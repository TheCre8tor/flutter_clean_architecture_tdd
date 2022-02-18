import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

final serviceLocator = GetIt.instance;

/* Difference between Factory & Singleton

   1. Factories: factories always instantiate a new
      instance of a given class whenever we request it.
      We will always get a new instance on every calls
      
   2. Singleton / Lazy Singleton: This will always grant
      the same instance after the first call to GetIt */

Future<void> init() async {
  //? Features / Screens - Number Trivia
  /* NOTE: The first thing which we are going to register is is 
     Bloc, because it's at the top of the call chain, when we go 
     from the UI down to does external data related dependency. */

  // 1. Bloc -->
  serviceLocator.registerFactory(
    // # Service Locator is also a callable class -->
    /* EXPLANATION: What happens inside the call method is 
       that the GetIt instance start looking for all of the 
       registered types. */
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator.call(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // 2. Use Cases -->
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(serviceLocator()),
  );

  // 3. Repository -->
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // 4. Data Source -->
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  //? Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  //? External
  serviceLocator.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  serviceLocator.registerLazySingleton(() => Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
