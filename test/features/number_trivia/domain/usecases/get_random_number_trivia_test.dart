import 'package:clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/repositories/base_number_trivia_repository.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRandomNumberTrivia extends Mock
    implements BaseNumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? usecase;
  MockRandomNumberTrivia? mockRandomNumberTrivia;

  setUp(() {
    mockRandomNumberTrivia = MockRandomNumberTrivia();
    usecase = GetRandomNumberTrivia(mockRandomNumberTrivia);
  });

  const testNumberTrivia = NumberTrivia(
    text: "This is a test response from Trivia",
    number: 1,
  );

  test('should get trivia from the repository', () async {
    // #1. arrange -->
    when(
      () => mockRandomNumberTrivia?.getRandomNumberTrivia(),
    ).thenAnswer((_) async => const Right(testNumberTrivia));

    // #2. act -->
    final result = await usecase?.call(NoParams());

    // #3. assert -->
    expect(result, const Right(testNumberTrivia));
    verify(() => mockRandomNumberTrivia?.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRandomNumberTrivia);
  });
}
