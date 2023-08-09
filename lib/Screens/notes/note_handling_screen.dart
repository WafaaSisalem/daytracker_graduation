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

class NoteHandlingScreen extends StatelessWidget {
  NoteHandlingScreen({
    Key? key,
    required this.type,
    this.note,
  }) : super(key: key);
  final NoteHandlingType type;
  NoteModel? note;
  String content = '';
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, NoteProvider>(
      builder: (context, authProvider, noteProvider, child) {
        content = note == null ? '' : note!.content;
        title = note == null ? '' : note!.title;
        return Scaffold(
          appBar: AppbarWidget(
              titlePlace: Row(children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18.r,
                    color: Colors.white, //TODO: COLOR
                  ),
                  onPressed: () {
                    if (type == NoteHandlingType.add) {
                      if (content == '' && title == '') {
                        AppRouter.router
                            .pushWithReplacementFunction(NoteHomeScreen());
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogWidget(
                                  dialogType: DialogType.discard,
                                  entryType: 'note',
                                  onOkPressed: (value) {
                                    AppRouter.router.pop();
                                    AppRouter.router
                                        .pushWithReplacementFunction(
                                            NoteHomeScreen());
                                  });
                            });
                      }
                    } else {
                      if (content == note!.content && title == note!.title) {
                        AppRouter.router
                            .pushWithReplacementFunction(NoteHomeScreen());
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogWidget(
                                  dialogType: DialogType.discard,
                                  entryType: 'note',
                                  onOkPressed: (value) {
                                    AppRouter.router.pop();
                                    AppRouter.router
                                        .pushWithReplacementFunction(
                                            NoteHomeScreen());
                                  });
                            });
                      }
                    }
                  },
                ),
                AppbarTextFieldWidget(
                    onChanged: (value) {
                      title = value;
                    },
                    hintText: 'Title',
                    autofocus: type == NoteHandlingType.display ? false : true,
                    text: type == NoteHandlingType.display ? title : null)
              ]),
              actions: [
                if (type == NoteHandlingType.display) ...[
                  InkWell(
                    // splashColor: Colors.transparent,
                    child: svgWhiteDelete, //TODO: CHANGE IT TO SVGPICTURE
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogWidget(
                                dialogType: DialogType.delete,
                                entryType: 'note',
                                onOkPressed: (value) {
                                  noteProvider.deleteNote(noteId: note!.id);
                                  AppRouter.router.pop();
                                  AppRouter.router.pushWithReplacementFunction(
                                      NoteHomeScreen());
                                });
                          });
                    },
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  InkWell(
                    // splashColor: Colors.transparent,
                    child: note!.isLocked ? svgWhiteUnlock : svgWhiteLock,
                    onTap: () {
                      if (noteProvider.userModel!.masterPassword.isEmpty) {
                        AppRouter.router.pushNamedFunction(
                            MasterPassScreen.routeName, [note]);
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
                                      if (noteProvider
                                              .userModel!.masterPassword ==
                                          value) {
                                        if (note!.isLocked) {
                                          noteProvider
                                              .updateNote(NoteModel.fromMap({
                                            ...note!.toMap(),
                                            Constants.isLockedKey: 0,
                                          }));
                                        } else {
                                          noteProvider
                                              .updateNote(NoteModel.fromMap({
                                            ...note!.toMap(),
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
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        if (type == NoteHandlingType.display) {
                          if (content == note!.content &&
                              title == note!.title) {
                            //do not do anything
                          } else if (content == '' && title == '') {
                            noteProvider.deleteNote(noteId: note!.id);
                          } else if (content != '' || title != '') {
                            noteProvider.deleteNote(noteId: note!.id);
                            noteProvider.addNote(
                                note: NoteModel(
                                    id: DateTime.now().toString(),
                                    content: content,
                                    date: DateTime.now(),
                                    title: title,
                                    isLocked: note!.isLocked));
                          }
                          AppRouter.router
                              .pushWithReplacementFunction(NoteHomeScreen());
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
                          AppRouter.router
                              .pushWithReplacementFunction(NoteHomeScreen());
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white, //TODO: COLOR
                      )),
                ),
              ]),
          body: Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: WritingPlaceWidget(
              onChanged: (value) {
                content = value;
              },
              contentText: type == NoteHandlingType.display ? content : null,
              hintText: 'note',
            ),
          ),
        );
      },
    );
  }
}
