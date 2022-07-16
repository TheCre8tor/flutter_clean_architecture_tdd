// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void numberTriviaModule() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => NumberTriviaBloc(
          getConcreteNumberTrivia: c<UseCase<NumberTrivia, Params>>(),
          getRandomNumberTrivia: c<UseCase<NumberTrivia, NoParams>>(),
          inputConverter: c<InputConverter>()))
      ..registerSingleton<UseCase<NumberTrivia, Params>>(
          (c) => GetConcreteNumberTrivia(c<BaseNumberTriviaRepository>()))
      ..registerSingleton<UseCase<NumberTrivia, NoParams>>(
          (c) => GetRandomNumberTrivia(c<BaseNumberTriviaRepository>()))
      ..registerFactory<BaseNumberTriviaRepository>((c) =>
          NumberTriviaRepository(
              remoteDataSource: c<BaseNumberTriviaRemoteDataSource>(),
              localDataSource: c<BaseNumberTriviaLocalDataSource>(),
              networkInfo: c<BaseNetworkInfo>()))
      ..registerSingleton<BaseNumberTriviaRemoteDataSource>(
          (c) => NumberTriviaRemoteDataSource(client: c<Client>()))
      ..registerSingleton<BaseNumberTriviaLocalDataSource>((c) =>
          NumberTriviaLocalDataSource(
              sharedPreferences: c<SharedPreferences>()))
      ..registerSingleton<BaseNetworkInfo>(
          (c) => NetworkInfo(c<InternetConnectionChecker>()))
      ..registerSingleton((c) => Client())
      ..registerSingleton((c) => InternetConnectionChecker())
      ..registerSingleton((c) => InputConverter());
  }

  @override
  void unknownModule() {}
}
