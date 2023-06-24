import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../../widgets/notes/writing_place.dart';
import '../../widgets/svgs/svgs.dart';
import 'journal_add_screen.dart';
import 'journal_home_screen.dart';

class JournalDisplayScreen extends StatelessWidget {
  List<Widget> widgets = [
    Image.asset(
      'assets/images/team.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/tanjiro.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/sunset.jpg',
      fit: BoxFit.cover,
    )
  ];
  JournalDisplayScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
          titlePlace: IconButton(
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
                        entryType: 'journal',
                        onOkPressed: (value) {
                          AppRouter.router.pop();
                          AppRouter.router
                              .pushWithReplacementFunction(JournalHomeScreen());
                        });
                  });
            },
          ),
          actions: [
            InkWell(
              // splashColor: Colors.transparent,
              child: svgWhiteDelete, //TODO: CHANGE IT TO SVGPICTURE
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogWidget(
                          dialogType: DialogType.delete,
                          entryType: 'journal',
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
                          entryType: 'journal',
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
                  svgEditIcon, //TODO: CHANGE IT TO SVGPICTURE AND CHAGE THE COLOR AND DELETE THE SVG IF YOU WANT !
              onTap: () {
                AppRouter.router
                    .pushWithReplacementFunction(JournalAddScreen());
              },
            ),
            SizedBox(
              width: 30.w,
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          children: [
            imageSlider(),
            SizedBox(
              height: 7.h,
            ),
            dateStack(context),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: WritingPlaceWidget(
                onChanged: (value) {},
                contentText:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                hintText: 'What happened with you today?',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {},
                  iconSize: 25.r,
                  color: Colors.grey, //TODO: COLOR
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {},
                  iconSize: 25.r,
                  color: Theme.of(context).colorScheme.secondary, //TODO: COLOR
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container imageSlider() {
    return Container(
      width: double.infinity,
      height: 150.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color(0x28000000), //TODO: COLOR
              offset: Offset(0, 3.h),
              blurRadius: 6),
        ],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: ImageSlideshow(
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
        children: widgets
            .map((e) => InkWell(
                  child: e,
                  onTap: () {
                    //TODO: GO TO IMAGEVIEWER SCREEN
                    print(e);
                  },
                ))
            .toList(),
      ),
    );
  }

  Stack dateStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 17.h,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(17.r)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 9.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              datecontainer(
                  context: context,
                  width: 30.w,
                  text: '11',
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 15.sp)),
              datecontainer(
                  context: context,
                  text: DateFormat('MMMM d, y').format(DateTime.now()),
                  width: 103.w,
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600)),
              datecontainer(
                context: context,
                width: 103.w,
                textStyle: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                text: DateFormat('EEEE. hh:mm a').format(DateTime.now()),
              ),
              datecontainer(
                  context: context,
                  width: 30.w,
                  text: '22',
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 15.sp))
            ],
          ),
        ),
      ],
    );
  }

  Container datecontainer({
    required BuildContext context,
    required double width,
    required String text,
    required TextStyle textStyle,
  }) {
    return Container(
      width: width,
      height: 30.h,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0x28000000), //TODO: COLOR
                offset: Offset(0, 1.h),
                blurRadius: 3),
          ],
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white // TODO: COLOR
          ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
