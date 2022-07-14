import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements BaseNumberTriviaRemoteDataSource {
  When mockConcreteCall() => when(() => getConcreteNumberTrivia(any()));

  /// Mocks methods for [getConcreteNumberTrivia]
  void mockConcrete(NumberTriviaModel data) {
    return mockConcreteCall().thenAnswer((_) async => data);
  }

  void mockConctreteError() => mockConcreteCall().thenThrow(ServerException());

  When mockRandomCall() => when(() => getRandomNumberTrivia());

  /// Mocks methods for [getRandomNumberTrivia]
  void mockRandom(NumberTriviaModel data) {
    return mockRandomCall().thenAnswer((_) async => data);
  }

  void mockRandomError() => mockRandomCall().thenThrow(ServerException());
}
