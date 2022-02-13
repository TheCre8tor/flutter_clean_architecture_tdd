import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {
  When mockCacheTriviaCall() => when(() => cacheNumberTrivia(any()));

  void mockCacheTrivia() {
    return mockCacheTriviaCall().thenAnswer((_) async => Future.value());
  }

  When mockLastTriviaCall() => when(() => getLastNumberTrivia());

  void mockLastTrivia(NumberTriviaModel data) {
    return mockLastTriviaCall().thenAnswer((_) async => data);
  }

  void mockLastTriviaError() {
    return mockLastTriviaCall().thenThrow(CacheException());
  }
}
