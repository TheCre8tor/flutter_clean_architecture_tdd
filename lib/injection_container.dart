import 'package:kiwi/kiwi.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository.dart';
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
      getConcreteNumberTrivia: c.resolve<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: c.resolve<GetRandomNumberTrivia>(),
      inputConverter: c.resolve<InputConverter>(),
    ),
  );

  // 2. Use Cases -->
  container.registerSingleton(
    (c) => GetConcreteNumberTrivia(c.resolve<NumberTriviaRepository>()),
  );

  container.registerSingleton(
    (c) => GetRandomNumberTrivia(c.resolve<NumberTriviaRepository>()),
  );

  // 3. Repository -->
  container.registerSingleton(
    (c) => NumberTriviaRepository(
      remoteDataSource: c.resolve<NumberTriviaRemoteDataSource>(),
      localDataSource: c.resolve<NumberTriviaLocalDataSource>(),
      networkInfo: c.resolve<NetworkInfo>(),
    ),
  );

  // 4. Data Source -->
  container.registerSingleton(
    (c) => NumberTriviaRemoteDataSource(client: c.resolve<Client>()),
  );

  container.registerSingleton(
    (c) => NumberTriviaLocalDataSource(
      sharedPreferences: c.resolve<SharedPreferences>(),
    ),
  );

  //? Core
  container.registerSingleton((c) => InputConverter());
  container.registerSingleton(
    (c) => NetworkInfo(c.resolve<InternetConnectionChecker>()),
  );

  //? External
  final sharedPreferences = await SharedPreferences.getInstance();
  container.registerSingleton((c) => sharedPreferences);

  container.registerSingleton((c) => Client());
  container.registerSingleton((c) => InternetConnectionChecker());
}
