import 'dart:convert';

import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../mocks/mock_http_client.dart';

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.parse("http://numbersapi.com/"));
  });

  group("getConcreteNumberTrivia", () {
    const testNumber = 1;
    final httpResponse = fixture("trivia.json");
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(httpResponse),
    );

    test(
      '''should perform a GET request on a URL with number being the endpoint and with `application/json` header''',
      () async {
        // arrange
        mockHttpClient?.mockHttpGet(httpResponse);

        // act
        dataSource!.getConcreteNumberTrivia(testNumber);

        // assert
        verify(() => mockHttpClient?.get(
              Uri.parse("http://numbersapi.com/$testNumber"),
              headers: {"Content-Type": "application/json"},
            ));
      },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        // arrange
        mockHttpClient?.mockHttpGet(httpResponse);

        // act
        final result = await dataSource?.getConcreteNumberTrivia(testNumber);

        // assert
        verify(() => mockHttpClient?.get(
              Uri.parse("http://numbersapi.com/$testNumber"),
              headers: {"Content-Type": "application/json"},
            ));
        expect(result, equals(testNumberTriviaModel));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        // arange
        mockHttpClient?.mockHttpGetError();

        // act
        final call = dataSource!.getConcreteNumberTrivia;

        // assert
        expect(() => call(testNumber),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group("getRandomNumberTrivia", () {
    final httpResponse = fixture("trivia.json");
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(httpResponse),
    );

    test(
      '''should perform a GET request on a URL with number being the endpoint and with `application/json` header''',
      () async {
        // arrange
        mockHttpClient?.mockHttpGet(httpResponse);

        // act
        dataSource!.getRandomNumberTrivia();

        // assert
        verify(() => mockHttpClient?.get(
              Uri.parse("http://numbersapi.com/random"),
              headers: {"Content-Type": "application/json"},
            ));
      },
    );

    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        // arrange
        mockHttpClient?.mockHttpGet(httpResponse);

        // act
        final result = await dataSource?.getRandomNumberTrivia();

        // assert
        verify(() => mockHttpClient?.get(
              Uri.parse("http://numbersapi.com/random"),
              headers: {"Content-Type": "application/json"},
            ));
        expect(result, equals(testNumberTriviaModel));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        // arange
        mockHttpClient?.mockHttpGetError();

        // act
        final call = dataSource!.getRandomNumberTrivia;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
