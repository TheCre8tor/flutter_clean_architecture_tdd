import 'dart:convert';

import 'package:clean_architecture_and_tdd/core/error/exception.dart';
import 'package:http/http.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{number} endpoints.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client? client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl("http://numbersapi.com/random");
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String uri) async {
    final response = await client?.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
    );

    if (response?.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response!.body));
    } else {
      throw ServerException();
    }
  }
}
