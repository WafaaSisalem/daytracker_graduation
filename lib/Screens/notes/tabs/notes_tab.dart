import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return widget.notes.isNotEmpty
        ? isRect
            ? rectangleNoteWidget()
            : squareNoteWidget()
        : Center(
            child: widget.noEntriesWidget,
          );
  }

  Container squareNoteWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: GridView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 36.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
         return buildItem(index:index, shape:NoteShape.square);
          }),
    );
  }
NoteWidget buildItem({context,required int index,required NoteShape shape}){
         selectedFlag[index] = selectedFlag[index] ?? false;
            bool isSelected = selectedFlag[index]!;

  return NoteWidget(
              isSelected: isSelected,
              isSelectionMode: isSelectionMode,
              onLongPress: () {
                onLongPress(isSelected, index);
              },
              shape: shape,
              title: widget.notes[index].title,
              date: widget.notes[index].date,
              content: widget.notes[index].content,
              id: widget.notes[index].id.toString(),
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
                          // take the password and save the note
                          print(value);
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
                        }));
                print('delete icon');
              },
            );
}
  Container rectangleNoteWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return buildItem(index: index, shape: NoteShape.rectangle);
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
      // Open Detail Page
      AppRouter.router.pushWithReplacementFunction(
          NoteHandlingScreen(type: NoteHandlingType.display));
    }
  }
}

          // selectedFlag[index] = selectedFlag[index] ?? false;
          // bool isSelected = selectedFlag[index]!;
          // return NoteWidget(
          //   isSelected: isSelected,
          //   isSelectionMode: isSelectionMode,
          //   onLongPress: () {
          //     onLongPress(isSelected, index);
          //   },
          //   shape: NoteShape.rectangle,
          //   title: widget.notes[index].title,
          //   date: widget.notes[index].date,
          //   content: widget.notes[index].content,
          //   id: widget.notes[index].id.toString(),
          //   onNoteTap: () {
          //     onTap(isSelected, index);
          //   },
          //   onPasswordIconTap: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) => DialogWidget(
          //             dialogType: DialogType.password,
          //             entryType: 'note',
          //             onOkPressed: (value) {
          //               // take the password and save the note
          //               print(value);
          //             }));
          //     print('password idonc');
          //   },
          //   onDeleteIconTap: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) => DialogWidget(
          //             dialogType: DialogType.delete,
          //             entryType: 'note',
          //             onOkPressed: (value) {
          //               print(widget.notes[index].id);
          //             }));
          //     print('delete icon');
          //   },
          // );