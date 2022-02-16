import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_and_tdd/core/error/failure.dart';
import 'package:clean_architecture_and_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_and_tdd/core/utils/input_converter.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {
  When mockInputConverterCall() {
    return when(() => stringToUnsignedInteger(any()));
  }

  // void mockInputConverter(int data) async {
  //   return mockInputConverterCall().thenReturn(Right(data));
  // }

  void mockInputConverter(int data) {
    return when(() => stringToUnsignedInteger(any())).thenReturn(Right(data));
  }
}

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  const testNumberString = "1";
  const testNumberParsed = 1;
  const testNumberTrivia = NumberTrivia(
    text: "This is a test response from Trivia",
    number: 1,
  );

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
    registerFallbackValue(const Params(number: testNumberParsed));
  });

  test("initialState should be Empty", () {
    // assert
    expect(bloc?.state, isA<Empty>());
    expect(bloc?.state, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should call the InputConverter to validate and convert the string to an unsigned integer",
      setUp: () {
        mockInputConverter?.mockInputConverter(testNumberParsed);
        when(
          () => mockGetConcreteNumberTrivia!(any()),
        ).thenAnswer((_) async => const Right(testNumberTrivia));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      verify: (_) => verify(
        () => mockInputConverter?.stringToUnsignedInteger(testNumberString),
      ),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Error] when the input is invalid",
      setUp: () {
        when(
          () => mockInputConverter?.stringToUnsignedInteger(any()),
        ).thenReturn(Left(InvalidInputFailure()));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      expect: () => [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
      verify: (_) => verify(
        () => mockInputConverter?.stringToUnsignedInteger(testNumberString),
      ),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should get data from concrete useCase",
      setUp: () {
        when(
          () => mockInputConverter?.stringToUnsignedInteger(any()),
        ).thenReturn(const Right(testNumberParsed));
        when(
          () => mockGetConcreteNumberTrivia!(any()),
        ).thenAnswer((_) async => const Right(testNumberTrivia));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      verify: (_) => verify(() {
        mockGetConcreteNumberTrivia!(const Params(number: testNumberParsed));
      }),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Loaded] when data is gotten successfully",
      setUp: () {
        when(
          () => mockInputConverter?.stringToUnsignedInteger(any()),
        ).thenReturn(const Right(testNumberParsed));
        when(
          () => mockGetConcreteNumberTrivia!(any()),
        ).thenAnswer((_) async => const Right(testNumberTrivia));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      expect: () => [
        Loading(),
        const Loaded(trivia: testNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Error] when data is gotten fails",
      setUp: () {
        when(
          () => mockInputConverter?.stringToUnsignedInteger(any()),
        ).thenReturn(const Right(testNumberParsed));
        when(
          () => mockGetConcreteNumberTrivia!(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Error] with proper mesage for the error when getting data fails.",
      setUp: () {
        when(
          () => mockInputConverter?.stringToUnsignedInteger(any()),
        ).thenReturn(const Right(testNumberParsed));
        when(
          () => mockGetConcreteNumberTrivia!(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(testNumberString),
      ),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group("GetTriviaForRandomNumber", () {
    setUp(() {
      registerFallbackValue(NoParams());
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should get data from random use case",
      setUp: () {
        when(
          () => mockGetRandomNumberTrivia!(any()),
        ).thenAnswer((_) async => const Right(testNumberTrivia));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      verify: (_) => verify(() {
        mockGetRandomNumberTrivia!(NoParams());
      }),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Loaded] when data is gotten successfully",
      setUp: () {
        when(
          () => mockGetRandomNumberTrivia!(any()),
        ).thenAnswer((_) async => const Right(testNumberTrivia));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const Loaded(trivia: testNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Error] when data is gotten fails",
      setUp: () {
        when(
          () => mockGetRandomNumberTrivia!(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [Loading, Error] with proper mesage for the error when getting data fails.",
      setUp: () {
        when(
          () => mockGetRandomNumberTrivia!(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => bloc!,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
