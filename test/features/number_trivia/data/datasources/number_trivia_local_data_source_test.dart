import 'dart:convert';

import 'package:clean_architecture_and_tdd/core/constants/local_storage_keys.dart';
import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../mocks/mock_shared_preferences.dart';

void main() {
  NumberTriviaLocalDataSource? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSource(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("getLastNumberTrivia", () {
    final localDataResponse = fixture("trivia_cached.json");
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(localDataResponse),
    );

    test(
      "should return NumberTriviaModel from SharedPreferences when there's one in the cache.",
      () async {
        // #1. arrange -->
        mockSharedPreferences?.mockLocalData(localDataResponse);

        // #2. act -->
        final result = await dataSource?.getLastNumberTrivia();

        // #3. assert -->
        verify(() => mockSharedPreferences?.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(testNumberTriviaModel));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      "should throw a CacheException when local storage is empty",
      () async {
        // #1. arrange -->
        mockSharedPreferences?.mockLocalDataError();

        // #2. act -->
        final call = dataSource!.getLastNumberTrivia;

        // #3. assert -->
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    const testNumberTriviaModel = NumberTriviaModel(
      text: "This is a test response from Trivia",
      number: 1,
    );

    test(
      "should call SharedPreferences to cache the data",
      () async {
        // arrange -->
        mockSharedPreferences?.mockSaveData();

        // act -->
        dataSource?.cacheNumberTrivia(testNumberTriviaModel);

        // assert -->
        final expectedJsonString = json.encode(testNumberTriviaModel.toJson());
        verify(() => mockSharedPreferences?.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ));
      },
    );
  });
}
