import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/usecases/usecase.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/data/repositories/base_number_trivia_repository.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/entities/number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

part 'injector.g.dart';

abstract class Injector {
  static final container = KiwiContainer();

  static Future<void> setup() async {
    var injector = _$Injector();
    injector.numberTriviaModule();
    injector.unknownModule();

    //! I Registered SharedPreferences this way
    //! because it need to be instantiated before
    //! actual registration with Kiwi.
    final sharedPreferences = await SharedPreferences.getInstance();
    container.registerSingleton((c) => sharedPreferences);
  }

  //! NumberTrivia Feature Module

  @Register.factory(NumberTriviaBloc)
  @Register.singleton(
    UseCase<NumberTrivia, Params>,
    from: GetConcreteNumberTrivia,
  )
  @Register.singleton(
    UseCase<NumberTrivia, NoParams>,
    from: GetRandomNumberTrivia,
  )
  @Register.factory(BaseNumberTriviaRepository, from: NumberTriviaRepository)
  @Register.singleton(
    BaseNumberTriviaRemoteDataSource,
    from: NumberTriviaRemoteDataSource,
  )
  @Register.singleton(
    BaseNumberTriviaLocalDataSource,
    from: NumberTriviaLocalDataSource,
  )
  @Register.singleton(BaseNetworkInfo, from: NetworkInfo)
  @Register.singleton(Client)
  @Register.singleton(InternetConnectionChecker)
  @Register.singleton(InputConverter)
  void numberTriviaModule();

  //! Any Other Feature Module
  void unknownModule();
}
