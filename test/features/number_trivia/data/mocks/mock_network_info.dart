import 'package:clean_architecture_and_tdd/core/platform/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {
  When mockNetworkCall() => when(() => isConnected);

  void mockOnline() => mockNetworkCall().thenAnswer((_) async => true);
  void mockOfflline() => mockNetworkCall().thenAnswer((_) async => false);
}
