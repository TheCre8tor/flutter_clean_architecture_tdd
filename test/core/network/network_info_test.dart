import 'package:clean_architecture_and_tdd/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {
  When mockInternetCall() => when(() => hasConnection);

  void mockInternet(Future<bool> data) {
    return mockInternetCall().thenAnswer((_) => data);
  }
}

void main() async {
  NetworkInfoImpl? networkInfo;
  MockInternetConnectionChecker? mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group("isConnected", () {
    test(
      "should forward the call to InternetConnectionChecker.hasConnection",
      () async {
        // #1. arrange -->
        final internetResponse = Future.value(true);
        mockInternetConnectionChecker?.mockInternet(internetResponse);

        // #2. act -->
        final result = networkInfo?.isConnected;

        // #3. assert -->
        verify(() => mockInternetConnectionChecker?.hasConnection);
        expect(result, equals(internetResponse));
      },
    );
  });
}
