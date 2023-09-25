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
  bool isLocked = false;
  late AuthProvider authProvider;
  late NoteProvider noteProvider;

  @override
  void initState() {
    isLocked = widget.note?.isLocked ?? false;
    super.initState();
  }

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
            // resizeToAvoidBottomInset: true,
            appBar: AppbarWidget(
                titlePlace: Row(children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 28,
                      color: Colors.white, //
                    ),
                    onPressed: () {
                      onBackButtonPressed();
                    },
                  ),
                  Expanded(child: buildTitleTextField())
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
        controller: widget.type == NoteHandlingType.display
            ? TextEditingController(text: content)
            : TextEditingController(text: null),
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
            Icons.check_rounded,
            size: 28,
            color: Colors.white, //
          )),
    );
  }

  InkWell buildLockIcon(BuildContext context) {
    return InkWell(
      child: SizedBox(
          width: 18,
          height: 18,
          child: isLocked ? svgWhiteUnlock : svgWhiteLock),
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
                          if (isLocked) {
                            noteProvider.updateNote(NoteModel.fromMap({
                              ...widget.note!.toMap(),
                              Constants.isLockedKey: 0,
                            }));
                            isLocked = false;
                            setState(() {});
                          } else {
                            noteProvider.updateNote(NoteModel.fromMap({
                              ...widget.note!.toMap(),
                              Constants.isLockedKey: 1,
                            }));
                            isLocked = true;
                            setState(() {});
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
      child: SizedBox(
        width: 18,
        height: 18,
        child: svgWhiteDelete,
      ),
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
                isLocked: isLocked!));
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
