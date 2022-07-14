import 'package:clean_architecture_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final _controller = TextEditingController();
  String? inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key("search_input_field"),
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (String value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                key: const Key("concrete_search"),
                onPressed: dispatchConcrete,
                child: const Text("Search"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                key: const Key("random_search"),
                onPressed: dispatchRandom,
                child: const Text("Get Random Trivia"),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    // We call clear on controller to empty
    // input field after submit.
    _controller.clear();

    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(
      inputStr!,
    ));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
