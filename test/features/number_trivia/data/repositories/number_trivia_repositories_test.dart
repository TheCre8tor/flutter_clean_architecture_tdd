import 'package:clean_architecture_and_tdd/core/error/failure.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_local_data_source.dart';
import '../mocks/mock_network_info.dart';
import '../mocks/mock_remote_data_source.dart';

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  const testNumber = 1;
  const testNumberTriviaModel = NumberTriviaModel(
    text: "This is a test response from Trivia",
    number: testNumber,
  );
  // We cast NumberTriviaModel object to NumberTrivia -->
  const NumberTrivia testNumberTrivia = testNumberTriviaModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    registerFallbackValue(testNumberTriviaModel);
  });

  group("getConcreteNumberTrivia", () {
    test("should check if the device is online.", () async {
      // #1. arrange -->
      mockNetworkInfo?.mockOnline();
      mockRemoteDataSource?.mockConcrete(testNumberTriviaModel);
      mockLocalDataSource?.mockCacheTrivia();

      // #2. act -->
      repository?.getConcreteNumberTrivia(testNumber);

      // #3. assert -->
      // Verify if `mockNetworkInfo?.isConnected` is called.
      verify(() => mockNetworkInfo?.isConnected);
    });

    group('device is online', () {
      setUp(() {
        // This setup is only applied to the `device is online`  group.
        mockNetworkInfo?.mockOnline();
        mockLocalDataSource?.mockCacheTrivia();
      });

      test(
        "should return remote data when the call to remote data source is successful",
        () async {
          // #1. arrange -->
          mockRemoteDataSource?.mockConcrete(testNumberTriviaModel);

          // #2. act -->
          final result = await repository?.getConcreteNumberTrivia(testNumber);

          // #3. assert -->
          verify(
            () => mockRemoteDataSource?.getConcreteNumberTrivia(testNumber),
          );
          expect(result, equals(const Right(testNumberTrivia)));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // #1. arrange -->
          mockRemoteDataSource?.mockConcrete(testNumberTriviaModel);

          // #2. act -->
          await repository?.getConcreteNumberTrivia(testNumber);

          // #3. assert -->
          /* Verify that `getConcreteNumberTrivia` is called with `testNumber` */
          verify(
            () => mockRemoteDataSource?.getConcreteNumberTrivia(testNumber),
          );
          /* Verify that `cacheNumberTrivia` is called with `testNumberTriviaModel` */
          verify(
            () => mockLocalDataSource?.cacheNumberTrivia(testNumberTriviaModel),
          );
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          // #1. arrange -->
          mockRemoteDataSource?.mockConctreteError();

          // #2. act -->
          final result = await repository?.getConcreteNumberTrivia(testNumber);

          // #3. assert -->
          verify(
            () => mockRemoteDataSource?.getConcreteNumberTrivia(testNumber),
          );
          // Verify nothing is cached, since we aint getting data from the datasource.
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        // This setup is only applied to the `device is offline` group.
        mockNetworkInfo?.mockOfflline();
      });

      test(
        "should return last locally cached data when the cached data is present",
        () async {
          // #1. arrange -->
          mockLocalDataSource?.mockLastTrivia(testNumberTriviaModel);

          // #2. act -->
          final result = await repository?.getConcreteNumberTrivia(testNumber);

          // #3. assert -->
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(const Right(testNumberTrivia)));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        "should return CacheFailure when there is no cached data present",
        () async {
          // #1. arrange -->
          mockLocalDataSource?.mockLastTriviaError();

          // #2. act -->
          final result = await repository?.getConcreteNumberTrivia(testNumber);

          // #3. assert -->
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });
  });

  group("getRandomNumberTrivia", () {});
}
