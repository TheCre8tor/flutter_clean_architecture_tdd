import 'package:clean_architecture_and_tdd/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfo extends Mock implements BaseNetworkInfo {
  When mockNetworkCall() => when(() => isConnected);

  void mockOnline() => mockNetworkCall().thenAnswer((_) async => true);
  void mockOfflline() => mockNetworkCall().thenAnswer((_) async => false);
}
