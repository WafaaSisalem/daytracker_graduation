import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/Screens/notes/widgets/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import 'widgets/writing_place.dart';
import '../../utils/svgs/svgs.dart';
import '../master_password_screen.dart';
import 'note_home_screen.dart';

enum NoteHandlingType { add, display }

class NoteHandlingScreen extends StatefulWidget {
  NoteHandlingScreen({
    Key? key,
    required this.type,
    this.note,
  }) : super(key: key);
  final NoteHandlingType type;
  NoteModel? note;

  @override
  State<NoteHandlingScreen> createState() => _NoteHandlingScreenState();
}

class _NoteHandlingScreenState extends State<NoteHandlingScreen> {
  String content = '';
  String title = '';
  late AuthProvider authProvider;
  late NoteProvider noteProvider;
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, NoteProvider>(
      builder: (context, authProvider, noteProvider, child) {
        this.authProvider = authProvider;
        this.noteProvider = noteProvider;
        content = widget.note == null ? '' : widget.note!.content;
        title = widget.note == null ? '' : widget.note!.title;
        return WillPopScope(
          onWillPop: () async {
            onCheckPressed();
            return false;
          },
          child: Scaffold(
            appBar: AppbarWidget(
                titlePlace: Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18.r,
                      color: Colors.white, //TODO: COLOR
                    ),
                    onPressed: () {
                      onBackButtonPressed();
                    },
                  ),
                  buildTitleTextField()
                ]),
                actions: [
                  if (widget.type == NoteHandlingType.display) ...[
                    buildDeleteIcon(context),
                    SizedBox(
                      width: 15.w,
                    ),
                    buildLockIcon(context),
                  ],
                  buildCheckIcon(),
                ]),
            body: buildBody(),
          ),
        );
      },
    );
  }

  Container buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: WritingPlaceWidget(
        onChanged: (value) {
          content = value;
        },
        contentText: widget.type == NoteHandlingType.display ? content : null,
        hintText: 'note',
      ),
    );
  }

  Padding buildCheckIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
          onPressed: () => onCheckPressed(),
          icon: const Icon(
            Icons.check,
            size: 18,
            color: Colors.white, //TODO: COLOR
          )),
    );
  }

  InkWell buildLockIcon(BuildContext context) {
    return InkWell(
      child: widget.note!.isLocked ? svgWhiteUnlock : svgWhiteLock,
      onTap: () {
        if (authProvider.userModel!.masterPassword.isEmpty) {
          AppRouter.router
              .pushNamedFunction(MasterPassScreen.routeName, [widget.note]);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return DialogWidget(
                    dialogType: DialogType.password,
                    entryType: 'note',
                    onOkPressed: (value) {
                      if (value.isEmpty) {
                        showToast('Password can not be empty!',
                            context: context);
                      } else {
                        if (authProvider.userModel!.masterPassword == value) {
                          if (widget.note!.isLocked) {
                            noteProvider.updateNote(NoteModel.fromMap({
                              ...widget.note!.toMap(),
                              Constants.isLockedKey: 0,
                            }));
                          } else {
                            noteProvider.updateNote(NoteModel.fromMap({
                              ...widget.note!.toMap(),
                              Constants.isLockedKey: 1,
                            }));
                          }

                          AppRouter.router.pop();
                          // AppRouter.router
                          //     .pushWithReplacementFunction(
                          //         NoteHomeScreen());
                        } else {
                          showToast('Wrong Password!',
                              context: context,
                              position: StyledToastPosition.top);
                        }
                      }
                    });
              });
        }
      },
    );
  }

  InkWell buildDeleteIcon(BuildContext context) {
    return InkWell(
      child: svgWhiteDelete,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return DialogWidget(
                  dialogType: DialogType.delete,
                  entryType: 'note',
                  onOkPressed: (value) {
                    noteProvider.deleteNote(noteId: widget.note!.id);
                    AppRouter.router.pop();
                    AppRouter.router
                        .pushWithReplacementFunction(const NoteHomeScreen());
                  });
            });
      },
    );
  }

  AppbarTextFieldWidget buildTitleTextField() {
    return AppbarTextFieldWidget(
        onChanged: (value) {
          title = value;
        },
        hintText: 'Title',
        autofocus: widget.type == NoteHandlingType.display ? false : true,
        text: widget.type == NoteHandlingType.display ? title : null);
  }

  Future<dynamic> discardDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
              dialogType: DialogType.discard,
              entryType: 'note',
              onOkPressed: (value) {
                AppRouter.router.pop();
                AppRouter.router
                    .pushWithReplacementFunction(const NoteHomeScreen());
              });
        });
  }

  onCheckPressed() {
    if (widget.type == NoteHandlingType.display) {
      if (content == widget.note!.content && title == widget.note!.title) {
        //do not do anything
      } else if (content == '' && title == '') {
        noteProvider.deleteNote(noteId: widget.note!.id);
      } else if (content != '' || title != '') {
        noteProvider.deleteNote(noteId: widget.note!.id);
        noteProvider.addNote(
            note: NoteModel(
                id: DateTime.now().toString(),
                content: content,
                date: DateTime.now(),
                title: title,
                isLocked: widget.note!.isLocked));
      }
      AppRouter.router.pushWithReplacementFunction(const NoteHomeScreen());
    } else {
      if (content != '' || title != '') {
        noteProvider.addNote(
            note: NoteModel(
                id: DateTime.now().toString(),
                content: content,
                date: DateTime.now(),
                title: title,
                isLocked: false));
      }
      AppRouter.router.pushWithReplacementFunction(const NoteHomeScreen());
    }
  }

  void onBackButtonPressed() {
    if (widget.type == NoteHandlingType.add) {
      if (content == '' && title == '') {
        AppRouter.router.pushWithReplacementFunction(const NoteHomeScreen());
      } else {
        discardDialog(context);
      }
    } else {
      if (content == widget.note!.content && title == widget.note!.title) {
        AppRouter.router.pushWithReplacementFunction(const NoteHomeScreen());
      } else {
        discardDialog(context);
      }
    }
  }
}
