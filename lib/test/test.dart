import 'package:flutter/material.dart';

/// Flutter code sample for [UndoHistoryController].

void main() {
  runApp(const UndoHistoryControllerExampleApp());
}

class UndoHistoryControllerExampleApp extends StatelessWidget {
  const UndoHistoryControllerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final UndoHistoryController _undoController = UndoHistoryController();

  TextStyle? get enabledStyle => Theme.of(context).textTheme.bodyMedium;
  TextStyle? get disabledStyle =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: TextField(
                  minLines: 1,
                  maxLines: MediaQuery.of(context).size.height.toInt() - 100,
                  cursorColor: Colors.grey, //TODO: color
                  controller: _controller,
                  focusNode: _focusNode,
                  undoController: _undoController,
                  decoration: InputDecoration(
                    hintText: 'dfdsflsdjfkldsj',
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(0),
                  )),
            ),
            Expanded(
              flex: 1,
              child: ValueListenableBuilder<UndoHistoryValue>(
                valueListenable: _undoController,
                builder: (BuildContext context, UndoHistoryValue value,
                    Widget? child) {
                  return Row(
                    children: <Widget>[
                      TextButton(
                        child: Text('Undo',
                            style:
                                value.canUndo ? enabledStyle : disabledStyle),
                        onPressed: () {
                          _undoController.undo();
                        },
                      ),
                      TextButton(
                        child: Text('Redo',
                            style:
                                value.canRedo ? enabledStyle : disabledStyle),
                        onPressed: () {
                          _undoController.redo();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
