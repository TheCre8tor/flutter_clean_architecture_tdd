import 'package:flutter/material.dart';
import './injection_container.dart' as dependency_injection;
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

void main() {
  dependency_injection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: NumberTriviaPage(),
    );
  }
}
