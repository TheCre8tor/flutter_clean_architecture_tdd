import 'dart:convert';

import 'package:clean_architecture_and_tdd/core/constants/local_storage_keys.dart';
import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences? sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences?.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      final jsonDecode = NumberTriviaModel.fromJson(json.decode(jsonString));
      return Future.value(jsonDecode);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia) async {
    final jsonEncodeString = json.encode(trivia.toJson());
    sharedPreferences?.setString(CACHED_NUMBER_TRIVIA, jsonEncodeString);
  }
}
