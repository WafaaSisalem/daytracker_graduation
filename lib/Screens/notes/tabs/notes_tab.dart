import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../../models/note_model.dart';
import '../../../router/app_router.dart';
import '../../../widgets/common/dialog_widget.dart';
import '../../../widgets/notes/note_widget.dart';
import '../note_handling_screen.dart';

class NotesTab extends StatefulWidget {
  NotesTab({
    Key? key,
    required this.noEntriesWidget,
    required this.notes,
  }) : super(key: key);
  final Widget noEntriesWidget;
  final List<NoteModel> notes;

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  bool isRect = true;
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (builder, noteProvider, x) {
      return widget.notes.isNotEmpty
          ? isRect
              ? rectangleNoteWidget(noteProvider)
              : squareNoteWidget(noteProvider)
          : Center(
              child: widget.noEntriesWidget,
            );
    });
  }

  Container squareNoteWidget(noteProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: GridView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 36.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            return buildItem(
                index: index,
                shape: NoteShape.square,
                context: context,
                noteProvider: noteProvider);
          }),
    );
  }

  NoteWidget buildItem(
      {required context,
      required int index,
      required NoteShape shape,
      required NoteProvider noteProvider}) {
    selectedFlag[index] = selectedFlag[index] ?? false;
    bool isSelected = selectedFlag[index]!;

    return NoteWidget(
      isSelected: isSelected,
      isSelectionMode: isSelectionMode,
      onLongPress: () {
        onLongPress(isSelected, index);
      },
      shape: shape,
      note: widget.notes[index],
      onNoteTap: () {
        onTap(isSelected, index);
      },
      onPasswordIconTap: () {
        showDialog(
            context: context,
            builder: (context) => DialogWidget(
                dialogType: DialogType.password,
                entryType: 'note',
                onOkPressed: (value) {
                  if (value.isEmpty) {
                    showToast('Password can not be empty!', context: context);
                  } else {
                    if (widget.notes[index].isLocked) {
                      if (widget.notes[index].password == value) {
                        unLockNote(noteProvider, index);
                        AppRouter.router.pop();
                      } else {
                        showToast('Wrong Password!',
                            context: context,
                            position: StyledToastPosition.top);
                      }
                    } else {
                      lockNote(noteProvider, index, value);
                      AppRouter.router.pop();
                    }
                  }
                }));
        print('password idonc');
      },
      onDeleteIconTap: () {
        showDialog(
            context: context,
            builder: (context) => DialogWidget(
                dialogType: DialogType.delete,
                entryType: 'note',
                onOkPressed: (value) {
                  print(widget.notes[index].id);
                  noteProvider.deleteNote(noteId: widget.notes[index].id);
                  AppRouter.router.pop();
                }));
        print('delete icon');
      },
    );
  }

  Container rectangleNoteWidget(noteProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return buildItem(
              index: index,
              shape: NoteShape.rectangle,
              context: context,
              noteProvider: noteProvider);
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 15.h,
        ),
        itemCount: widget.notes.length,
      ),
    );
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
      //TODO: make a delete icon in tab bar by adding selection mode in provider
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      if (widget.notes[index].isLocked) {
        showDialog(
            context: context,
            builder: (context) => DialogWidget(
                dialogType: DialogType.password,
                entryType: 'note',
                onOkPressed: (value) {
                  if (value.isEmpty) {
                    showToast('Password can not be empty!', context: context);
                  } else {
                    if (widget.notes[index].password == value) {
                      AppRouter.router.pop();
                      AppRouter.router
                          .pushWithReplacementFunction(NoteHandlingScreen(
                        type: NoteHandlingType.display,
                        note: widget.notes[index],
                      ));
                    } else {
                      showToast('Wrong Password!',
                          context: context, position: StyledToastPosition.top);
                    }
                  }
                }));
      } else {
        AppRouter.router.pushWithReplacementFunction(NoteHandlingScreen(
          type: NoteHandlingType.display,
          note: widget.notes[index],
        ));
      }
    }
  }

  void unLockNote(NoteProvider noteProvider, int index) {
    noteProvider.updateNote(NoteModel.fromMap({
      ...widget.notes[index].toMap(),
      Constants.isLockedKey: false,
      Constants.passwordKey: '',
    }));
  }

  void lockNote(NoteProvider noteProvider, int index, String value) {
    noteProvider.updateNote(NoteModel.fromMap({
      ...widget.notes[index].toMap(),
      Constants.isLockedKey: true,
      Constants.passwordKey: value,
    }));
  }
}
