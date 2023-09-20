import 'dart:async';

import 'package:day_tracker_graduation/Screens/master_password_screen.dart';
import 'package:day_tracker_graduation/helpers/shared_preference_helper.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../../models/note_model.dart';
import '../../../router/app_router.dart';
import '../../../widgets/dialog_widget.dart';
import '../widgets/note_widget.dart';
import '../note_handling_screen.dart';

class NotesTab extends StatefulWidget {
  NotesTab(
      {Key? key,
      required this.noEntriesWidget,
      required this.notes,
      required this.longPressActivated})
      : super(key: key);
  final Widget noEntriesWidget;
  final List<NoteModel> notes;
  final bool longPressActivated;

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  bool isLoading = true;
  late AuthProvider authProvider;
  late NoteProvider noteProvider;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NoteProvider, AuthProvider>(
        builder: (builder, noteProvider, authProvider, x) {
      this.noteProvider = noteProvider;
      this.authProvider = authProvider;
      return widget.notes.isNotEmpty
          ? SharedPreferenceHelper.sharedHelper.getView() == 1
              ? buildRectangleList()
              : buildSquareList()
          : Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : widget.noEntriesWidget,
            );
    });
  }

  Container buildSquareList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: GridView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 36.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            return buildItem(
                index: index, shape: NoteShape.square, context: context);
          }),
    );
  }

  NoteWidget buildItem({
    required context,
    required int index,
    required NoteShape shape,
  }) {
    // noteProvider.selectedFlag[index] =
    //     noteProvider.selectedFlag[index] ?? false;

    bool isSelected = noteProvider.selectedFlag[index]!;

    return NoteWidget(
      isSelected: isSelected,
      isSelectionMode: noteProvider.isSelectionMode,
      onLongPress: () {
        if (widget.longPressActivated) {
          onLongPress(isSelected, index);
        }
      },
      shape: shape,
      note: widget.notes[index],
      onNoteTap: () {
        onTap(isSelected, index);
      },
      onPasswordIconTap: () {
        onPassword(index);
      },
      onDeleteIconTap: () {
        onDelete(index);
      },
    );
  }

  Future<dynamic> deleteDialog(int index) {
    return showDialog(
        context: context,
        builder: (context) => DialogWidget(
            dialogType: DialogType.delete,
            entryType: 'note',
            onOkPressed: (value) {
              noteProvider.deleteNote(noteId: widget.notes[index].id);
              AppRouter.router.pop();
            }));
  }

  Container buildRectangleList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return buildItem(
            index: index,
            shape: NoteShape.rectangle,
            context: context,
          );
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
      noteProvider.selectedFlag[index] = !isSelected;
      noteProvider.setSelectionMode();
    });
  }

  void onTap(bool isSelected, int index) {
    if (noteProvider.isSelectionMode) {
      setState(() {
        noteProvider.selectedFlag[index] = !isSelected;
        noteProvider.setSelectionMode();
      });
    } else {
      if (widget.notes[index].isLocked) {
        passwordDialog(whenMatch: () {
          AppRouter.router.pushWithReplacementFunction(NoteHandlingScreen(
            type: NoteHandlingType.display,
            note: widget.notes[index],
          ));
        });
      } else {
        AppRouter.router.pushWithReplacementFunction(NoteHandlingScreen(
          type: NoteHandlingType.display,
          note: widget.notes[index],
        ));
      }
    }
  }

  Future<dynamic> passwordDialog({required Function() whenMatch}) {
    return showDialog(
        context: context,
        builder: (context) => DialogWidget(
            dialogType: DialogType.password,
            entryType: 'note',
            onOkPressed: (value) {
              if (value.isEmpty) {
                showToast('Password can not be empty!', context: context);
              } else {
                // if (noteProvider.userModel!.masterPassword == value)
                if (authProvider.userModel!.masterPassword == value) {
                  AppRouter.router.pop();
                  whenMatch();
                } else {
                  showToast('Wrong Password!',
                      context: context, position: StyledToastPosition.top);
                }
              }
            }));
  }

  void onPassword(index) {
    if (authProvider.userModel!.masterPassword.isEmpty) {
      AppRouter.router
          .pushNamedFunction(MasterPassScreen.routeName, [widget.notes[index]]);
    } else {
      passwordDialog(whenMatch: () {
        if (widget.notes[index].isLocked) {
          noteProvider.updateNote(NoteModel.fromMap({
            ...widget.notes[index].toMap(),
            Constants.isLockedKey: 0,
          }));
        } else {
          noteProvider.updateNote(NoteModel.fromMap({
            ...widget.notes[index].toMap(),
            Constants.isLockedKey: 1,
          }));
        }
      });
    }
  }

  void onDelete(int index) {
    if (widget.notes[index].isLocked) {
      passwordDialog(whenMatch: () {
        deleteDialog(index);
      });
    } else {
      deleteDialog(index);
    }
  }
}
