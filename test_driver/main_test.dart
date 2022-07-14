// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Number Trivia Page', () {
    FlutterDriver? driver;

    String vmServURL = 'ws://127.0.0.1:8888';

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect(dartVmServiceUrl: vmServURL);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });

    test("should search for trivia with a number of 12", () async {
      // Arrange -->
      final acquireFocus = find.byValueKey("search_input_field");
      final concreteSearchButton = find.byValueKey("concrete_search");

      // Act -->
      await driver?.tap(acquireFocus);
      await driver?.enterText("12");
      await driver?.tap(concreteSearchButton);

      // assert -->
      await driver?.waitFor(find.text("12"));
    });

    test('should search for trivia with random numbers', () async {
      // arrange -->
      final randomSearchButton = find.byValueKey("random_search");

      // act -->
      await driver?.tap(randomSearchButton);

      // assert -->
      await driver?.waitFor(find.byType("TriviaDisplay"));
      await driver?.waitFor(find.byValueKey("loaded_trivia"));
    });
  });
}
