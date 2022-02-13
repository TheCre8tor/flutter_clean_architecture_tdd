import 'dart:convert';

import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(
    number: 1,
    text: "This is a test response from Trivia",
  );

  test("should be a subclass of NumberTrivia entity", () async {
    // assert -->
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test(
      "should return a valid model when the JSON `number` field is an integer",
      () async {
        // #1. arrange -->

        final Map<String, dynamic> jsonMap = json.decode(
          fixture("trivia.json"),
        );

        // #2. act -->
        final result = NumberTriviaModel.fromJson(jsonMap);

        // #3. assert -->
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      "should return a valid model when the JSON `number` field is regarded as a double",
      () async {
        // #1. arrange -->

        final Map<String, dynamic> jsonMap = json.decode(
          fixture("trivia_double.json"),
        );

        // #2. act -->
        final result = NumberTriviaModel.fromJson(jsonMap);

        // #3. assert -->
        expect(result, equals(testNumberTriviaModel));
      },
    );
  });

  group("toJson", () {
    test(
      "should return a JSON containing the proper data.",
      () async {
        // act -->
        final result = testNumberTriviaModel.toJson();

        // assert -->
        const expectedMap = {
          "text": "This is a test response from Trivia",
          "number": 1,
        };

        expect(result, equals(expectedMap));
      },
    );
  });
}
