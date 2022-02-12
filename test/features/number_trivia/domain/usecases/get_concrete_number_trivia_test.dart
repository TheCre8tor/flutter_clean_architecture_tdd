import 'package:clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  const testNumber = 1;
  const testNumberTrivia = NumberTrivia(
    text: "This is a test response from Trivia",
    number: testNumber,
  );

  test('should get trivia for the number from the repository', () async {
    // #1. arrange -->
    when(() => mockNumberTriviaRepository?.getConcreteNumberTrivia(any()))
        .thenAnswer((invocation) async => const Right(testNumberTrivia));

    // #2. act -->
    final result = await usecase?.call(const Params(testNumber));

    // #3 assert -->
    expect(result, const Right(testNumberTrivia));

    /* NOTE: We want to verify that `getConcreteNumberTrivia` 
       method was truly called with `testNumber` */
    verify(
      () => mockNumberTriviaRepository?.getConcreteNumberTrivia(testNumber),
    );

    /* NOTE: We verify no more interactions are 
       happening on the `mockNumberTriviaRepository`
       because ones we call usecase?.execute(), the 
       usecase should not do anything more after.  */
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
