import 'package:clean_architecture_and_tdd/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => Injector.container.resolve<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const MessageDisplay(
                          key: Key("initial_state"),
                          message: "Start searching...",
                        );
                      } else if (state is Loading) {
                        return const LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(
                          key: const Key("loaded_trivia"),
                          numberTrivia: state.trivia,
                        );
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      }

                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: const Placeholder(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const TriviaControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
