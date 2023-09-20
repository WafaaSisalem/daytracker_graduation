import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/pomo_provider.dart';
import '../utils/constants.dart';
import 'dialog_textfield.dart';

enum DialogType { discard, delete, password, quote, end, addTask, editTask }

class DialogWidget extends StatefulWidget {
  DialogWidget(
      {Key? key,
      required this.dialogType,
      required this.entryType,
      required this.onOkPressed,
      this.content,
      this.onNextPressed})
      : super(key: key);

  final String entryType;
  final DialogType dialogType;
  final Function(String) onOkPressed;
  Function(String)? onNextPressed;
  final String? content;
  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? dialogTitle;
  Widget? dialogContent;
  String value = '';
  late PomoProvider pomoProvider;
  bool nextButton = false;
  initValues() {
    //final pomoProvider = Provider.of<PomoProvider>(context);
    switch (widget.dialogType) {
      case DialogType.delete:
        dialogTitle = 'Delete';
        dialogContent =
            Text('Do you want to delete this ${widget.entryType} entry?');
        break;
      case DialogType.discard:
        dialogTitle = 'Discard';
        dialogContent = const Text('Do you want to discard the changes?');
        break;
      case DialogType.password:
        dialogTitle = 'Password';
        dialogContent = DialogTextFieldWidget(
          isObscured: true,
          hintText: '',
          onChanged: (value) {
            this.value = value;
          },
        );
        break;
      case DialogType.quote:
        dialogTitle = 'Quote';
        dialogContent = DialogTextFieldWidget(
          isObscured: false,
          hintText: 'write a quote to get excited!',
          onChanged: (value) {
            this.value = value;
          },
        );
        break;
      case DialogType.end:
        dialogTitle = 'End this pomo?';
        dialogContent = Text(pomoProvider.duration.inMinutes >= 1
            ? Constants.doEnd
            : Constants.notSaved);
        break;
      case DialogType.addTask:
        dialogTitle = 'Add Task';
        dialogContent = DialogTextFieldWidget(
            isObscured: false,
            hintText: 'write a task',
            onChanged: (value) {
              this.value = value;
            });
        nextButton = true;
        break;
      case DialogType.editTask:
        dialogTitle = 'Edit Task';
        dialogContent = DialogTextFieldWidget(
            isObscured: false,
            content: widget.content,
            hintText: 'write a task',
            onChanged: (value) {
              this.value = value;
            });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pomoProvider = Provider.of<PomoProvider>(context);
    initValues();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white, //TODO: COLOR
      contentPadding:
          EdgeInsets.only(top: 10.h, bottom: 0, left: 20.w, right: 20.w),
      titlePadding: EdgeInsets.only(top: 20.h, bottom: 0, left: 20.w),
      title: Text(
        dialogTitle!,
        style: theme.textTheme.headline6,
      ),
      content: dialogContent,
      actions: [
        if (nextButton) ...[
          TextButton(
              onPressed: () {
                widget.onNextPressed!(value);
              },
              child: Text(
                'Next',
                style: theme.textTheme.headline6,
                // color
              )),
          TextButton(
            onPressed: null,
            child: SizedBox(),
          )
        ],
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCEL',
                style: theme.textTheme.headline6!
                    .copyWith(color: const Color(0xFFE0BFEA)) // color
                )),
        TextButton(
            onPressed: () {
              widget.onOkPressed(value);
            },
            child: Text(
              'OK',
              style: theme.textTheme.headline6,
            )),
      ],
    );
  }
}
