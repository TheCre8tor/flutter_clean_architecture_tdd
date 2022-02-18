import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_and_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: BlocProvider(
        create: (_) => serviceLocator<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: const Text("Start searching!"),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3,
                      child: const Placeholder(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Placeholder(fallbackHeight: 20),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Expanded(
                          child: Placeholder(
                            fallbackHeight: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Placeholder(
                            fallbackHeight: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
