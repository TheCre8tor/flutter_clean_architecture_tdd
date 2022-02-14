import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {
  When mockHttpGetCall() {
    return when(() => this.get(any(), headers: any(named: "headers")));
  }

  void mockHttpGet(String data) {
    return mockHttpGetCall().thenAnswer((_) async => Response(data, 200));
  }

  void mockHttpGetError() {
    const msg = "Something went wrong";
    return mockHttpGetCall().thenAnswer((_) async => Response(msg, 404));
  }
}
