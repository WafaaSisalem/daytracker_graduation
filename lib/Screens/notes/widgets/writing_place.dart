import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WritingPlaceWidget extends StatelessWidget {
  WritingPlaceWidget(
      {Key? key,
      required this.onChanged,
      required this.controller,
      required this.hintText,
      this.enabled = true})
      : super(key: key);

  final Function(String) onChanged;
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  late BuildContext context;
  final FocusNode focusNode = FocusNode();
  final UndoHistoryController undoController = UndoHistoryController();

  Color? get enabledStyle => Theme.of(context).primaryColor;
  Color? get disabledStyle => Colors.grey;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: TextField(
            minLines: 1,
            maxLines: MediaQuery.of(context).size.height.toInt() - 100,
            cursorColor: Colors.grey, //TODO: color
            controller: controller,
            focusNode: focusNode,
            undoController: undoController,
            enabled: enabled,
            onChanged: onChanged,
            style: theme.textTheme.headline4!
                .copyWith(height: 1.5.h, fontSize: 18),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(0),
                hintText: hintText,
                hintStyle: theme.textTheme.headline4!
                    .copyWith(color: const Color(0x80707070))), //TODO: color
          ),
        ),
        Expanded(
          flex: 1,
          child: ValueListenableBuilder<UndoHistoryValue>(
            valueListenable: undoController,
            builder:
                (BuildContext context, UndoHistoryValue value, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.undo,
                      color: value.canUndo ? enabledStyle : disabledStyle,
                    ),
                    onPressed: () {
                      undoController.undo();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.redo,
                        color: value.canRedo ? enabledStyle : disabledStyle),
                    onPressed: () {
                      undoController.redo();
                    },
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
