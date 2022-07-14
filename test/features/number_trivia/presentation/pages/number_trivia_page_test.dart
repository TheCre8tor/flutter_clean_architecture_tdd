import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_and_tdd/injection_container.dart' as di;

class MockNumberTriviaBloc extends Mock implements NumberTriviaBloc {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

void main() {
  MockNumberTriviaBloc? mockNumberTriviaBloc = MockNumberTriviaBloc();

  const Widget testWidget = MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      home: NumberTriviaPage(),
    ),
  );

  setUp(() async {
    await di.init();
    // mockNumberTriviaBloc = MockNumberTriviaBloc();
    // serviceLocator.allowReassignment = true;
    // serviceLocator.registerLazySingleton<NumberTriviaBloc>(
    //   () => mockNumberTriviaBloc,
    // );
    // when(() => mockNumberTriviaBloc.getConcreteNumberTrivia).thenAnswer((_) => GetConcreteNumberTrivia(repository));
    // when(() => mockNumberTriviaBloc.state).thenAnswer((_) => Empty());
  });

  group("Number Trivia Page", () {
    testWidgets(
      "should check if the initial state of the page is Empty",
      (WidgetTester tester) async {
        when(() => mockNumberTriviaBloc.state).thenAnswer((_) => Empty());

        await tester.pumpWidget(testWidget);

        expect(mockNumberTriviaBloc.state, Empty());
        expect(find.byKey(const Key("initial_state")), findsOneWidget);
      },
    );

    testWidgets("should tap the search button", (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      // await tester.tap(find.byKey(Key("")))
    });
  });
}
