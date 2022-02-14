import 'dart:convert';

import 'package:clean_architecture_and_tdd/core/constants/local_storage_keys.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  When mockLocalDataCall() => when(() => getString(any()));

  void mockLocalData(String data) => mockLocalDataCall().thenReturn(data);
}

void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
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
  });
}
