import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../../widgets/common/floating_calendar.dart';
import '../../widgets/journals/expandable_fab.dart';
import '../../widgets/notes/writing_place.dart';
import '../../widgets/svgs/svgs.dart';
import 'journal_display_screen.dart';
import 'journal_home_screen.dart';

class JournalAddScreen extends StatefulWidget {
  const JournalAddScreen({Key? key}) : super(key: key);

  @override
  State<JournalAddScreen> createState() => _JournalAddScreenState();
}

class _JournalAddScreenState extends State<JournalAddScreen> {
  String date = DateFormat('MMMM d, y').format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                                JournalHomeScreen());
                          });
                    });
              },
            ),
            SizedBox(
              width: 70.w,
            ),
            InkWell(
              onTap: () async {
                var val = await floatingCalendarWidget(context);
                setState(() {
                  date = DateFormat('MMMM d, y').format(val).toString();
                });
              },
              child: Container(
                height: 23.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        height: 15.h,
                        width: 1.w,
                        color: Colors.grey[200],
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.colorScheme.secondary,
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    AppRouter.router
                        .pushWithReplacementFunction(JournalDisplayScreen());
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
          contentText: '',
          hintText: 'What happened with you today?',
        ),
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      ),
      floatingActionButton: ExpandableFab(
        children: [
          ActionButton(
            onPressed: () {
              print('gallary pressed!');
            },
            icon: svgGallery,
          ),
          ActionButton(
            onPressed: () {
              print('map pressed!');
            },
            icon: svgMap,
          ),
          ActionButton(
            onPressed: () {
              print('weather pressed!');
            },
            icon: svgWeather,
          ),
          ActionButton(
            onPressed: () {
              print('smile pressed!');
            },
            icon: svgSmile,
          ),
        ],
      ),
    );
  }
}
