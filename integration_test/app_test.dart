import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:clean_architecture_and_tdd/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Number Trivia Page', () {
    //! Ensure Kiwi - IoC container and WidgetsFlutterBinding
    //! is initialized bofore running any test.
    app.main();

    testWidgets(
      "should search for trivia with a number of 12",
      (tester) async {
        // Load the MyApp Widget
        await tester.pumpWidget(const app.MyApp());

        // wait for data to load
        await tester.pumpAndSettle();

        final Finder acquireFocus = find.byKey(const Key("search_input_field"));
        final Finder concreteSearchButton = find.byKey(
          const Key("concrete_search"),
        );

        await tester.tap(acquireFocus);
        await tester.pumpAndSettle();

        await tester.enterText(acquireFocus, "12");
        await tester.pumpAndSettle();

        await tester.tap(concreteSearchButton);
        await tester.pumpAndSettle();

        expect(find.text("12"), findsOneWidget);
      },
    );

    testWidgets(
      'should search for trivia with random numbers',
      (tester) async {
        // Load the MyApp Widget
        await tester.pumpWidget(const app.MyApp());

        // wait for data to load
        await tester.pumpAndSettle();

        final Finder randomSeachButton = find.byKey(const Key("random_search"));

        await tester.tap(randomSeachButton);
        await tester.pumpAndSettle();

        expect(find.byType(TriviaDisplay), findsOneWidget);
        expect(find.byKey(const Key("loaded_trivia")), findsOneWidget);
      },
    );
  });
}
