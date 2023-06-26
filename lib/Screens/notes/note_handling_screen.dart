import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:day_tracker_graduation/services/auth_helper.dart';
import 'package:day_tracker_graduation/services/firestore_helper.dart';
import 'package:day_tracker_graduation/widgets/notes/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../../widgets/notes/writing_place.dart';
import '../../widgets/svgs/svgs.dart';
import 'note_home_screen.dart';

enum NoteHandlingType { add, display }

class NoteHandlingScreen extends StatelessWidget {
  const NoteHandlingScreen({
    Key? key,
    required this.type,
  }) : super(key: key);
  final NoteHandlingType type;
  @override
  Widget build(BuildContext context) {
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
                            AppRouter.router
                                .pushWithReplacementFunction(NoteHomeScreen());
                          });
                    });
              },
            ),
            AppbarTextFieldWidget(
                onChanged: (value) {},
                hintText: 'Title',
                autofocus: type == NoteHandlingType.display ? false : true,
                text: type == NoteHandlingType.display ? 'First NOte' : null)
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
                            onOkPressed: (value) {});
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
                            onOkPressed: (value) {});
                      });
                },
              ),
            ],
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    if (type == NoteHandlingType.display) {
                      AppRouter.router
                          .pushWithReplacementFunction(const NoteHomeScreen());
                    } else {
                      FirestoreHelper.firestoreHelper.addNoteToUser(
                          note: NoteModel(
                                  id: 1,
                                  content:
                                      'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece It is a long established fact that a readera piece It is...',
                                  date: DateFormat('MMMM d, y. EEE. hh:mm a')
                                      .format(DateTime.now()),
                                  title: 'First note')
                              .toMap(),
                          userId: AuthHelper
                              .authHelper.firebaseAuth.currentUser!.uid);
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
        child: WritingPlaceWidget(
          onChanged: (value) {},
          contentText: type == NoteHandlingType.display
              ? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
              : null,
          hintText: 'note',
        ),
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      ),
    );
  }
}
