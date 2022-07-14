import 'package:clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:kiwi/kiwi.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/entities/number_trivia.dart';
import 'features/number_trivia/data/repositories/base_number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

final container = KiwiContainer();

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
  container.registerFactory(
    // # Service Locator is also a callable class -->
    /* EXPLANATION: What happens inside the call method is 
       that the GetIt instance start looking for all of the 
       registered types. */
    (c) => NumberTriviaBloc(
      getConcreteNumberTrivia: GetConcreteNumberTrivia(
        c.resolve<NumberTriviaRepository>(),
      ),
      getRandomNumberTrivia: GetRandomNumberTrivia(
        c.resolve<NumberTriviaRepository>(),
      ),
      inputConverter: c.resolve<InputConverter>(),
    ),
  );

  // 2. Use Cases -->
  // container.registerSingleton(
  //   (c) => GetConcreteNumberTrivia(c.resolve<BaseNumberTriviaRepository>()),
  // );

  // container.registerSingleton(
  //   (c) => GetRandomNumberTrivia(c.resolve<BaseNumberTriviaRepository>()),
  // );

  // 3. Repository -->
  container.registerSingleton(
    (c) => NumberTriviaRepository(
      remoteDataSource: NumberTriviaRemoteDataSource(
        client: c.resolve<Client>(),
      ),
      localDataSource: NumberTriviaLocalDataSource(
        sharedPreferences: c.resolve<SharedPreferences>(),
      ),
      networkInfo: NetworkInfoImpl(c.resolve<InternetConnectionChecker>()),
    ),
  );

  // 4. Data Source -->
  // container.registerLazySingleton<NumberTriviaRemoteDataSource>(
  //   () => NumberTriviaRemoteDataSourceImpl(client: container()),
  // );
  // container.registerLazySingleton<NumberTriviaLocalDataSource>(
  //   () => NumberTriviaLocalDataSourceImpl(sharedPreferences: container()),
  // );

  //? Core
  container.registerSingleton<InputConverter>((c) => InputConverter());
  // container.registerSingleton<NetworkInfo>(
  //   (c) => NetworkInfoImpl(container()),
  // );

  //? External
  final sharedPreferences = await SharedPreferences.getInstance();
  container.registerSingleton<SharedPreferences>(
    (c) => sharedPreferences,
  );

  container.registerSingleton<Client>((c) => Client());
  container.registerSingleton<InternetConnectionChecker>(
    (c) => InternetConnectionChecker(),
  );
}
