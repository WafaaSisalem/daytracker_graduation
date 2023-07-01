import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:day_tracker_graduation/widgets/notes/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../../widgets/notes/writing_place.dart';
import '../../widgets/svgs/svgs.dart';
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                              dialogType: DialogType.discard,
                              entryType: 'note',
                              onOkPressed: (value) {
                                AppRouter.router.pop();
                                AppRouter.router.pushWithReplacementFunction(
                                    NoteHomeScreen());
                              });
                        });
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
                    child:
                        svgWhiteLock, //TODO: CHANGE IT TO SVGPICTURE AND CHAGE THE COLOR AND DELETE THE SVG IF YOU WANT !
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogWidget(
                                dialogType: DialogType.password,
                                entryType: 'note',
                                onOkPressed: (value) {
                                  noteProvider.deleteNote(noteId: note!.id);
                                  noteProvider.addNote(
                                      note: NoteModel(
                                          id: note!.id,
                                          content: content,
                                          date: note!.date,
                                          title: title,
                                          password: value));
                                  AppRouter.router.pop();
                                });
                          });
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
                                    password: note!.password));
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
                                    title: title));
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
