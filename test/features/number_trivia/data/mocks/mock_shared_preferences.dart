import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  When mockLocalDataCall() => when(() => getString(any()));

  void mockLocalData(String data) => mockLocalDataCall().thenReturn(data);
  void mockLocalDataError() => mockLocalDataCall().thenReturn(null);

  When mockSaveDataCall() => when(() => setString(any(), any()));
  void mockSaveData() {
    when(() => mockSaveDataCall().thenAnswer((_) => Future.value(true)));
  }
}
