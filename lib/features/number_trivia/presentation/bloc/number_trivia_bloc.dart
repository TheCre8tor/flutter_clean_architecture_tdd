import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = "Server Failure";
// ignore: constant_identifier_names
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
// ignore: constant_identifier_names
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid Input - The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final UseCase<NumberTrivia, Params>? getConcreteNumberTrivia;
  final UseCase<NumberTrivia, NoParams>? getRandomNumberTrivia;
  final InputConverter? inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumber);
  }

  void _getTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = inputConverter?.stringToUnsignedInteger(
      event.numberString,
    );

    await inputEither!.fold((Failure failure) {
      emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (int integer) async {
      emit(Loading());

      // We are making an async operation here
      // so we have to await so we have to await
      // inputEither!.fold
      final failureOrTrivia = await getConcreteNumberTrivia!(
        Params(number: integer),
      );

      _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }

  void _getTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final failureOrTrivia = await getRandomNumberTrivia!(NoParams());

    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) async {
    await failureOrTrivia.fold((Failure failure) {
      emit(Error(message: failure.mapFailureToMessage(failure)));
    }, (NumberTrivia trivia) {
      emit(Loaded(trivia: trivia));
    });
  }
}
